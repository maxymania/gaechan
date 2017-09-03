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

import com.google.common.io.BaseEncoding;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import webidee.gaechan.Facade;

/**
 *
 * @author Simon Schmidt
 */
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String redirect = req.getParameter("redirect");
        String user = req.getParameter("user");
        String passwd = req.getParameter("passwd");
        if(redirect==null)redirect="/";
        if(redirect.isEmpty())redirect="/";
        Facade.setRedirect(resp, redirect);
        if(user==null)user = "";
        if(passwd==null)passwd = "";
        if(!user.isEmpty()){
            String trapkey = user+"#"+passwd;
            byte[] data = trapkey.getBytes(Facade.BYTES);
            Cookie cook = new Cookie(Facade.CHAN_CRED_TRIPSEQ,BaseEncoding.base64Url().encode(data));
            if((Boolean)req.getAttribute("chan.security.crutch"))
                cook.setSecure(true);
            cook.setMaxAge(60*60*24*180);
            resp.addCookie(cook);
        }
        
    }
    
}
