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

import com.google.common.io.BaseEncoding;
import java.nio.charset.Charset;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.bouncycastle.crypto.digests.Blake2bDigest;

/**
 *
 * @author Simon Schmidt
 */
public class Facade {
    public static final String ANONYMOUS = "UN-NAMED";
    public static final String CHAN_CRED_TRIPSEQ = "chan_cred_tripseq";
    public static final String ATTR_TRAPCODE = "chan.trapcode";
    public static final String ATTR_LOGGEDIN = "chan.is_login";
    public static final Charset BYTES; // Emulating java.nio.charset.StandardCharsets
    static{
        Charset csv = null;
        Charset[] csa = {
            Charset.forName("ISO-8859-1"),
            Charset.forName("UTF-8"),
            Charset.forName("US-ASCII"),
            Charset.defaultCharset(),
        };
        for(Charset cs:csa)if(cs!=null){csv = cs;break;}
        BYTES = csv;
    }
    
    public static void setRedirect(HttpServletResponse response,String url){
        response.setHeader("Location", url);
        response.setStatus(302);
    }
    public static String calcTrapcodeBase64(String credentials){
        try{
            Blake2bDigest digest = new Blake2bDigest(256);
            byte[] b = BaseEncoding.base64Url().decode(credentials);
            digest.update(b, 0, b.length);
            byte[] h = new byte[32];
            digest.doFinal(h, 0);
            return BaseEncoding.base64Url().encode(h);
        }catch(Exception e){
            return ANONYMOUS;
        }
    }
}
