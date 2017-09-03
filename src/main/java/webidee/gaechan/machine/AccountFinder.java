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
package webidee.gaechan.machine;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.common.base.Objects;
import static com.googlecode.objectify.ObjectifyService.ofy;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import webidee.gaechan.machine.util.BAFileItemFactory;
import webidee.gaechan.mdl.Account;

/**
 *
 * @author Simon Schmidt
 */
public class AccountFinder {
    public static Class<Account> TAB = Account.class;
    public static Account updateOwnAccount(String trapcode,HttpServletRequest hsr) {
        Account account = ofy().load().type(Account.class).id(trapcode).now();
        if("post".equalsIgnoreCase(hsr.getMethod())){
            BAFileItemFactory ff = new BAFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(ff);
            upload.setFileSizeMax(1<<19);
            if(account==null) {
                account = new Account();
                account.me = trapcode;
                account.owner = trapcode;
            }
            try{
                String urlname = "";
                String add_url = "";
                ImagesService imgs = null;
                for(FileItem item:upload.parseRequest(hsr)){
                    if(item.isFormField()){
                        
                        switch(""+item.getFieldName()){
                            case "set_description":
                                account.description = item.getString();
                                break;
                            case "delete_url":
                                account.websites.remove(Integer.parseInt(item.getString()));
                                break;
                            case "urlname":
                                add_url = item.getString();
                                break;
                            case "add_url":
                                add_url = item.getString();
                                break;
                        }
                        if(!add_url.isEmpty()&&!urlname.isEmpty()){
                            account.websites.add(urlname+": "+add_url);
                        }
                        String i = item.getString();
                    }else{
                        byte[] data = item.get();
                        if(imgs==null)imgs = ImagesServiceFactory.getImagesService();
                        Image img = ImagesServiceFactory.makeImage(data);
                        ;
                        img = imgs.applyTransform(ImagesServiceFactory.makeResize(128, 128), img, ImagesService.OutputEncoding.JPEG);
                        account.picture = img.getImageData();
                    }
                }
                ofy().save().entity(account).now();
            }catch(Exception e){
                
            }
        }
        if(account==null) return new Account();
        return account;
    }
    public static Account getOwnAccount(String trapcode) {
        Account account = ofy().load().type(TAB).id(trapcode).now();
        if(account==null) return new Account();
        if(!Objects.equal(account.me, account.owner)){
            return new Account();
        }
        return account;
    }
    public static Account getAliasAccount(String trapcode) {
        Account account = ofy().load().type(TAB).id(trapcode).now();
        if(account==null) return new Account();
        if(!Objects.equal(account.me, account.owner)){
            account = ofy().load().type(TAB).id(account.owner).now();
            if(account==null) return new Account();
        }
        return account;
    }
    public static List<Account> getChildren(String trapcode){
        return ofy().load().type(Account.class).filter("owner", trapcode).list();
    }
}
