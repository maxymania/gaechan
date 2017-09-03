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
package webidee.gaechan.machine.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemHeaders;

/**
 *
 * @author Simon Schmidt
 */
public class ArrayFileItem implements FileItem{
    private ByteArrayOutputStream baos = new ByteArrayOutputStream();

    public ArrayFileItem() {
    }

    @Override
    public InputStream getInputStream() throws IOException {
        return new ByteArrayInputStream(get());
    }

    public String contentType;
    @Override
    public String getContentType() {
        return contentType;
    }

    public String name;
    @Override
    public String getName() {
        return name;
    }

    @Override
    public boolean isInMemory() {
        return true;
    }

    @Override
    public long getSize() {
        return baos.size();
    }

    @Override
    public byte[] get() {
        return baos.toByteArray();
    }

    @Override
    public String getString(String encoding) throws UnsupportedEncodingException {
        return new String(get(),encoding);
    }

    @Override
    public String getString() {
        return new String(get());
    }

    @Override
    public void write(File file) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete() {
    }

    private String fieldName;
    @Override
    public String getFieldName() {
        return fieldName;
    }

    @Override
    public void setFieldName(String name) {
        fieldName = name;
    }

    boolean formField;
    @Override
    public boolean isFormField() {
        return formField;
    }

    @Override
    public void setFormField(boolean state) {
        formField = state;
    }

    @Override
    public OutputStream getOutputStream() throws IOException {
        return baos;
    }

    FileItemHeaders headers;
    @Override
    public FileItemHeaders getHeaders() {
        return headers;
    }

    @Override
    public void setHeaders(FileItemHeaders headers) {
        this.headers = headers;
    }
    
}
