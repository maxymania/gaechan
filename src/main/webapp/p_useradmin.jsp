<%--
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
--%>
<%@page import="webidee.gaechan.mdl.Account,java.util.List,org.apache.commons.text.StringEscapeUtils" %>
<div style="border: solid 1px #ccc; margin: 0 auto; width: 980px;">
    <%
        
        String trapcode = (String)request.getAttribute("chan.trapcode");
        Account acc = webidee.gaechan.machine.AccountFinder.getOwnAccount(trapcode);
        List<Account> childs = webidee.gaechan.machine.AccountFinder.getChildren(trapcode);
    %>
    <table>
        <tbody>
            <tr>
                <th>Trapcode</th>
                <td colspan="3"><%=StringEscapeUtils.escapeHtml4(acc.me)%></td>
            </tr>
            <tr>
                <th>Avatar</th>
                <td colspan="3"><img src="/userimg/<%=acc.me%>"/></td>
            </tr>
            <tr>
                <th></th>
                <td colspan="3">
                    <form method="POST" action="/usract/upload.jsp" enctype="multipart/form-data" style="display: inline">
                        <input name="set_image" type="file" size="50"/> 
                        <button type="submit">Put Image</button>
                    </form>
                </td>
            </tr>
            <tr>
                <th></th>
                <td colspan="3">
                    <form method="POST" action="/usract/randpic.jsp" style="display: inline">
                        Identifier:
                        <input name="email" type="text"/>
                        <input name="type" type="hidden" value="adorable"/>
                        <button type="submit">Get from Adorable-Avatars</button>
                    </form>
                    See also <a href="http://avatars.adorable.io/">avatars.adorable.io</a>
                </td>
            </tr>
            <tr>
                <th></th>
                <td colspan="3">
                    <form method="POST" action="/usract/randpic.jsp" style="display: inline">
                        Category:
                        <select name="cat">
                            <option value="abstract">abstract</option>
                            <option value="animals">animals</option>
                            <option value="business">business</option>
                            <option value="cats">cats</option>
                            <option value="city">city</option>
                            <option value="food">food</option>
                            <option value="nightlife">nightlife</option>
                            <option value="fashion">fashion</option>
                            <option value="people">people</option>
                            <option value="nature">nature</option>
                            <option value="sports">sports</option>
                            <option value="technics">technics</option>
                            <option value="transport">transport</option>
                        </select>
                        Text:
                        <input name="text" type="text"/>
                        
                        <input name="type" type="hidden" value="lorempixel"/>
                        <button type="submit">Get from lorempixel.com</button>
                    </form>
                    See also <a href="http://lorempixel.com/">lorempixel.com</a>
                </td>
            </tr>
            <tr>
                <th>Description</th>
                <td colspan="3">
                    <form method="POST" action="/usract/description.jsp">
                        <textarea name="description"><%=StringEscapeUtils.escapeHtml4(acc.description)%></textarea>
                        <button type="submit">Save</button>
                    </form>
                </td>
            </tr>
            <tr>
                <th><span class="u">Personal</span> Notes</th>
                <td colspan="3">
                    (!) Personal Notes are notes to yourself. Only you can read them, bobody else.
                    <form method="POST" action="/usract/persnotes.jsp">
                        <textarea name="persnotes"><%=StringEscapeUtils.escapeHtml4(acc.personalNotes)%></textarea>
                        <button type="submit">Save</button>
                    </form>
                </td>
            </tr>
            <tr>
                <th>Websites</th>
                <td colspan="2">
                    <ul>
                        <%
                            int i=0;
                            if(acc.websites!=null)for(String site:acc.websites){
                        %>
                        <li>
                            <%= site%>
                            <form style="display: inline;" method="POST" action="/usract/remurl.jsp">
                                <input type="hidden" value="<%= i%>" name="urlidx" />
                                <button type="submit">Delete</button>
                            </form>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                </td>
                <td>
                    <form style="display: inline;" method="POST" action="/usract/addurl.jsp">
                        (name)<input type="text" name="urlname" />:
                        (url)<input type="text" name="urlpath" />
                        <button type="submit">Add</button>
                    </form>
                </td>
            </tr>
            <tr>
                <th>Aliases</th>
                <td colspan="3">
                    <ul>
                    <%
                        if(childs!=null)for(Account child:childs){
                            if(trapcode.equals(child.me))continue;
                            String name = StringEscapeUtils.escapeHtml4(child.me);
                    %>
                    <li>
                        <%= name%>
                        <form style="display: inline;" method="POST" action="/usract/remalias.jsp">
                            <input type="hidden" value="<%= name%>" name="alias" />
                            <button type="submit">Delete</button>
                        </form>
                    </li>
                    <%
                        }
                    %>
                    </ul>
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <form style="display: inline;" method="POST" action="/usract/addalias.jsp">
                        <input type="text" name="a_username" autocomplete="off"/>#
                        <input type="text" name="a_password" autocomplete="off"/>
                        <button type="submit">Add</button>
                    </form>
                </td>
            </tr>
        </tbody>
    </table>
</div>