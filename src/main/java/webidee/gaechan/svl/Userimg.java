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

import com.google.common.base.Objects;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.googlecode.objectify.ObjectifyService.ofy;
import webidee.gaechan.mdl.Account;

/**
 *
 * @author Simon Schmidt
 */
public class Userimg extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pi = req.getPathInfo();
        if(pi==null)pi="";
        pi = pi.replaceAll("^\\/+|\\/+$", "");
        Account acc = ofy().load().type(Account.class).id(pi).now();
        if(acc==null){
            resp.sendError(404);
            return;
        }
        if(!(acc.owner==null||Objects.equal(acc.me, acc.owner))){
            acc = ofy().load().type(Account.class).id(acc.owner).now();
        }
        if(acc.picture==null)
            resp.sendError(404);
        else if(acc.picture.length==0)
            resp.sendError(404);
        else
        {
            resp.setContentType("image/jpeg");
            resp.getOutputStream().write(acc.picture);
        }
    }
}
