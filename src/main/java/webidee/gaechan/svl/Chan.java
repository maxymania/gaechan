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

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Simon Schmidt
 */
public class Chan extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        perform(req,resp);
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        perform(req,resp);
    }
    
    private void perform(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<String> ostr = new ArrayList();
        String pi = req.getPathInfo();
        if(pi==null)pi="";
        for(String str:pi.split("\\/")){
            if(str.isEmpty())continue;
            ostr.add(str.replace("[\\=\\&]", ""));
        }
        String url = getUrl(ostr.iterator());
        req.getRequestDispatcher(url).forward(req, resp);
    }
    private String getUrl(Iterator<String> i){
        if(!i.hasNext()) return "/index.jsp";
        StringBuilder sb = new StringBuilder("?");
        sb.append("chan=").append(i.next());
        if(!i.hasNext()) return "/r_chan.jsp"+sb;
        sb.append("&thrd=").append(i.next());
        sb.append("&page=");
        if(!i.hasNext())sb.append("1");
        else sb.append(i.next());
        return "/r_thrd.jsp"+sb;
    }
}
