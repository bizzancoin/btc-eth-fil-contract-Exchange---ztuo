package com.bizzan.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.util.Base64;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Created by wonderful on 2017/6/20.
 * 基本理论：
 * 图片所占内存大小：图片长 x 图片宽 x 一个像素点占用的字节数组
 * 图片压缩格式：
 * Bitmap.Config.ARGB_8888  一个像素4个字节
 * Bitmap.Config.ARGB_565 一个像素2个字节
 **/

public class WonderfulBitmapUtils {

    /**
     * 采样率压缩：
     * 按照指定 宽高压缩图片
     * 默认 780 * 460
     *
     * @param is
     * @param width
     * @param height
     * @return
     * @throws IOException
     */
    public static Bitmap loadBitmap(InputStream is, int width, int height) throws IOException {
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024 * 5];
        int length = 0;
        while ((length = is.read(buffer)) != -1) {
            os.write(buffer, 0, length);
            os.flush();
        }
        byte[] bytes = os.toByteArray();
        is.close();
        os.close();
        BitmapFactory.Options opts = new BitmapFactory.Options();
        opts.inJustDecodeBounds = true;
        BitmapFactory.decodeByteArray(bytes, 0, bytes.length, opts);
        int w = opts.outWidth / width;
        int h = opts.outHeight / height;
        int scale = w > h ? w : h;
        if (scale < 1) {
            scale = 1;
        }
        opts.inJustDecodeBounds = false;
        opts.inSampleSize = scale;
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length, opts);
    }

    /**
     * 将指定bitmap对象存到文件中
     *
     * @param quality 质量压缩比率 取值 0--100 有些无损格式如png将忽略此设置不被压缩
     */
    public static void saveBitmapToFile(Bitmap bitmap, File file, int quality) throws IOException {
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        if (file.exists()) {
            file.delete();
            file.createNewFile();
        }
        FileOutputStream fos = new FileOutputStream(file);
        bitmap.compress(Bitmap.CompressFormat.WEBP, quality, fos);
        fos.close();
    }

    public static Bitmap zoomBitmap(Bitmap bitmap, int w, int h) {
        try {
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();
            Matrix matrix = new Matrix();
            float scaleWidth = ((float) w / width);
            float scaleHeight = ((float) h / height);
            matrix.postScale(scaleWidth, scaleHeight);
            bitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true);
            return bitmap;
        }catch (Exception e){
            return null;
        }

    }



    /**
     * 转换为base64格式
     */
    public static String imgToBase64(Bitmap bitmap) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out);
        try {
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        byte[] imgBytes = out.toByteArray();
        return Base64.encodeToString(imgBytes, Base64.NO_WRAP);//Android 类库
//        return BASE64Encoder.encode(imgBytes);// 解决换行问题
    }


}
