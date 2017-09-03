/*
 * The MIT License
 *
 * Copyright 2017 Simon Schmidt.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package webidee.gaechan.svl;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.common.base.Strings;
import com.googlecode.objectify.ObjectifyService;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import webidee.gaechan.Facade;
import webidee.gaechan.mdl.Account;
import webidee.gaechan.mdl.Chan;
import webidee.gaechan.mdl.Chanthrd;
import webidee.gaechan.mdl.ChanthrdPage;
import webidee.gaechan.mdl.ChanthrdPageEntry;

/**
 *
 * @author Simon Schmidt
 */
public class CredHashing implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        ObjectifyService.register(Account.class);
        ObjectifyService.register(Chan.class);
        ObjectifyService.register(Chanthrd.class);
        ObjectifyService.register(ChanthrdPage.class);
        ObjectifyService.register(ChanthrdPageEntry.class);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        before((HttpServletRequest)request,(HttpServletResponse)response);
        chain.doFilter(request, response);
        after((HttpServletRequest)request,(HttpServletResponse)response);
    }
    private void before(HttpServletRequest request, HttpServletResponse response){
        
        if(request.getAttribute("chan.http.uri")==null)
            request.setAttribute("chan.http.uri", request.getRequestURI());
        if(request.getAttribute("chan.http.full_url")==null)
            request.setAttribute("chan.http.full_url", ""+request.getRequestURL());
        
        if(request.getAttribute(Facade.ATTR_TRAPCODE)==null){
            String trapcode = Facade.ANONYMOUS;
            String credentials = "<nil>";
            boolean isLogin = false;
            
            Cookie[] cka = request.getCookies();
            if(cka!=null)for(Cookie ck:cka) {
                switch(ck.getName()){
                    case Facade.CHAN_CRED_TRIPSEQ:
                        trapcode = Facade.calcTrapcodeBase64(credentials = ck.getValue());
                        isLogin = true;
                        break;
                }
            }
            request.setAttribute(Facade.ATTR_TRAPCODE, trapcode);
            request.setAttribute(Facade.ATTR_LOGGEDIN, isLogin);
            request.setAttribute("debug.credentials", credentials);
        }
        
        if(request.getAttribute("google.user.is_login")==null){
            UserService service = UserServiceFactory.getUserService();
            boolean is_login = service.isUserLoggedIn();
            boolean is_admin = false;
            String login_url = null,logout_url = null;
            if(is_login){
                is_admin   = service.isUserAdmin();
                logout_url = service.createLogoutURL(request.getRequestURI());
            }else{
                login_url  = service.createLoginURL(request.getRequestURI());
            }
            request.setAttribute("google.user.is_login", is_login);
            request.setAttribute("google.user.is_admin", is_admin);
            request.setAttribute("google.url.login" , login_url );
            request.setAttribute("google.url.logout", logout_url);
        }
        
        if(request.getAttribute("chan.security.crutch")==null){
            boolean useCrutch;
            //useCrutch = "localhost".equalsIgnoreCase(Strings.nullToEmpty(request.getLocalName()).replaceFirst("\\:.*$", ""));
            useCrutch = true;
            request.setAttribute("chan.security.crutch", useCrutch);
            request.setAttribute("chan.security.secure", useCrutch?request.isSecure():true);
            String url = ""+request.getAttribute("chan.http.full_url");
            url = url.replaceFirst("^http\\:", "https:").replaceFirst("(https\\:\\/\\/[^\\/\\:]+)\\:[0-9]+","$1");
            request.setAttribute("chan.security.https", url);
        }
    }
    private void after(HttpServletRequest request, HttpServletResponse response){}

    @Override
    public void destroy() {
    }
}
