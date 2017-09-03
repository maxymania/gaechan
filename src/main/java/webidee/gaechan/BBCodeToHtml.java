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
package webidee.gaechan;

import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.text.StringEscapeUtils;

/**
 *
 * @author Simon Schmidt
 */
public class BBCodeToHtml {
    /*
    \[(\/?)([a-zA-Z0-9]+)((\=[^\]]*)?)\]
    \n\r?\n\r?
    */
    public static final Pattern TAGS = Pattern.compile("\\[(\\/?)([a-zA-Z0-9]+)((\\=[^\\]]*)?)\\]");
    public static final Pattern BRL = Pattern.compile("\\n\\r?\\n\\r?");
    public static String bb2html(String source){
        StringEscapeUtils.escapeHtml4("a");
        Matcher match = TAGS.matcher(source);
        int position = 0;
        StringBuilder sb = new StringBuilder();
        Stack<String> intag = new Stack();
        Stack<String> outtag = new Stack();
        boolean nosubtag = false;
        
        while(match.find()){
            String appended = source.substring(position, match.start());
            
            if(!nosubtag){
                Matcher mat = BRL.matcher(appended);
                int ps=0;
                while(mat.find()){
                    sb.append(StringEscapeUtils.escapeHtml4(appended.substring(ps,mat.start())));
                    ps = mat.end();
                    sb.append("<br>");
                }
                appended = appended.substring(ps);
            }
            sb.append(StringEscapeUtils.escapeHtml4(appended));
            position = match.end();
            
            if("/".equals(match.group(1))){
                if(!intag.empty())
                if(intag.peek().equals(match.group(2).toLowerCase())){
                    nosubtag = false;
                    intag.pop();
                    String ot = outtag.pop();
                    if(ot.startsWith("@")){
                        String[] ota = ot.substring(1).split("\\@",2);
                        sb.append(ota[0]).append(StringEscapeUtils.escapeHtml4(appended)).append(ota[1]);
                    }else
                        sb.append(ot);
                };
            }else if(nosubtag){
            }else{
                
                String ty = match.group(2).toLowerCase();
                intag.push(ty);
                switch(ty){
                    case "u":
                    case "strike":
                    case "overline":
                        sb.append("<span class=\""+ty+"\">");
                        outtag.push("</span>");
                        break;
                    case "url":
                        sb.append("<a");
                        if(match.group(3).startsWith("=")){
                            sb      .append(" href=\"")
                                    .append(StringEscapeUtils.escapeHtml4(match.group(3).substring(1)))
                                    .append("\">");
                            // ------------------------------------------
                            outtag.push("</a>");
                        }else{
                            sb.append(" href=\"");
                            outtag.push("@\">@</a>");
                            nosubtag = true;
                        }
                        break;
                    case "h1":
                    case "h2":
                    case "h3":
                    case "i":
                    case "b":
                    case "sub":
                    case "sup":
                        sb.append("<"+ty+">");
                        outtag.push("</"+ty+">");
                        break;
                    case "img":
                        sb.append("<img ");
                        if(match.group(3).startsWith("=")){
                            String[] sizes = match.group(3).substring(1).split("[,x]");
                            sb.append("width=\"").append(sizes[0]).append("\" ");
                            if(sizes.length>1) sb.append("height=\"").append(sizes[1]).append("\" ");
                        }
                        sb.append("src=\"");
                        outtag.push("\">");
                        nosubtag = true;
                        break;
                    case "quote":
                        sb.append("<blockquote>");
                        if(match.group(3).startsWith("=")){
                            sb.append("<span class=\"who\">");
                            String arg = match.group(3).substring(1);
                            boolean isLink = arg.indexOf('/')>=0;
                            if(isLink){
                                sb.append("<a href=\"").append(StringEscapeUtils.escapeHtml4(arg)).append("\">");
                                if(arg.length()>32)arg = arg.substring(0, 32)+"...";
                            }
                            sb.append(StringEscapeUtils.escapeHtml4(arg));
                            if(isLink)sb.append("</a>");
                            sb.append("</span>");
                        }
                        outtag.push("</blockquote>");
                        break;
                    default: intag.pop(); // Undo!
                }
            }
        }
        
        {
            String last = source.substring(position);
            {
                Matcher mat = BRL.matcher(last);
                int ps=0;
                while(mat.find()){
                    sb.append(StringEscapeUtils.escapeHtml4(last.substring(ps,mat.start())));
                    ps = mat.end();
                    sb.append("<br>");
                }
                last = last.substring(ps);
            }
            sb.append(StringEscapeUtils.escapeHtml4(last));
        }
        while(!outtag.empty()){
            String ot = outtag.pop();
            if(ot.startsWith("@")){
                String[] ota = ot.substring(1).split("\\@",2);
                sb.append(ota[0]).append(ota[1]);
            }else{
                sb.append(ot);
            }
        }
        return sb.toString();
    }
}
