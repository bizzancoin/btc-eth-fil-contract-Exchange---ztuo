package com.bizzan.ui.home;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.ParseException;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.gyf.barlibrary.ImmersionBar;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;
import com.bizzan.R;
import com.bizzan.adapter.shareApkImageAdapter;
import com.bizzan.app.MyApplication;
import com.bizzan.app.UrlFactory;
import com.bizzan.base.BaseTransFragment;
import com.bizzan.entity.Coin;
import com.bizzan.entity.SafeSetting;
import com.bizzan.entity.User;
import com.bizzan.ui.account_pwd.AccountPwdActivity;
import com.bizzan.ui.account_pwd.EditAccountPwdActivity;
import com.bizzan.ui.bind_account.BindAccountActivity;
import com.bizzan.ui.ctc.CTCActivity;
import com.bizzan.ui.entrust.TrustListActivity;
import com.bizzan.ui.login.LoginActivity;
import com.bizzan.ui.my_ads.AdsActivity;
import com.bizzan.ui.my_order.MyOrderActivity;
import com.bizzan.ui.myinfo.MyInfoActivity;
import com.bizzan.ui.setting.SettingActivity;
import com.bizzan.ui.wallet.WalletActivity;
import com.bizzan.ui.wallet_detail.WalletDetailActivity;
import com.bizzan.utils.SavePhoto;
import com.bizzan.utils.SharedPreferenceInstance;
import com.bizzan.utils.WonderfulCommonUtils;
import com.bizzan.utils.WonderfulStringUtils;
import com.bizzan.utils.WonderfulToastUtils;
import com.bizzan.utils.okhttp.StringCallback;
import com.bizzan.utils.okhttp.WonderfulOkhttpUtils;
import com.bizzan.widget.FivePopInvite;
import okhttp3.Request;

/**
 * Created by Administrator on 2018/1/29.
 */

public class FiveFragment extends BaseTransFragment implements MainContract.FiveView, View.OnClickListener {
    public static final String TAG = FiveFragment.class.getSimpleName();
    @BindView(R.id.llTop)
    LinearLayout llTop;
    @BindView(R.id.llAccount)
    LinearLayout llAccount;
    @BindView(R.id.llOrder)
    LinearLayout llOrder;
    @BindView(R.id.llAds)
    LinearLayout llAds;
    @BindView(R.id.line_top)
    LinearLayout line_top;
    @BindView(R.id.line_zican)
    LinearLayout line_zican;
    @BindView(R.id.line_shoukuan)
    LinearLayout line_shoukuan;
    @BindView(R.id.line_jypwd)
    LinearLayout line_jypwd;
    @BindView(R.id.line_bibi)
    LinearLayout line_bibi;
    @BindView(R.id.line_ctc)
    LinearLayout line_ctc;
    @BindView(R.id.line_security)
    LinearLayout line_security;
    @BindView(R.id.llSafe)
    ImageView llSafe;
    @BindView(R.id.llSettings)
    ImageView llSettings;
    @BindView(R.id.llMyinfo)
    LinearLayout llMyinfo;
    @BindView(R.id.tvNickName)
    TextView tvNickName;
    @BindView(R.id.tvAccount)
    TextView tvAccount;

    @BindView(R.id.tvLevelOneCount)
    TextView tvLevelOneCount;
    @BindView(R.id.tvLevelTwoCount)
    TextView tvLevelTwoCount;
    @BindView(R.id.tvEstimatedReward)
    TextView tvEstimatedReward;
    @BindView(R.id.tvCurrentLevel)
    TextView tvCurrentLevel;
    @BindView(R.id.tvMyPromotionCode)
    TextView tvMyPromotionCode;

    @BindView(R.id.ivHeader)
    ImageView ivHeader;
    public static double sumUsd = 0;
    double sumCny = 0;
    @BindView(R.id.llEntrust)
    LinearLayout llEntrust;
    Unbinder unbinder;
    @BindView(R.id.img)
    ImageView img;
    private MainContract.FivePresenter presenter;
    private SafeSetting safeSetting;
    private PopupWindow loadingPopup;
    private FivePopInvite fivePopInvite;
    private String dir = Environment.getExternalStorageDirectory().getAbsolutePath() + "/ATC/";//图片/
    private shareApkImageAdapter adapter;
    private ArrayList<Integer> imagebitmap;

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_five;
    }

    /**
     * 初始化加载dialog
     */
    private void initLoadingPopup() {
        View loadingView = getLayoutInflater().inflate(R.layout.pop_loading, null);
        loadingPopup = new PopupWindow(loadingView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        loadingPopup.setFocusable(true);
        loadingPopup.setClippingEnabled(false);
        loadingPopup.setBackgroundDrawable(new ColorDrawable());
    }

    /**
     * 显示加载框
     */
    @Override
    public void displayLoadingPopup() {
        loadingPopup.showAtLocation(getActivity().getWindow().getDecorView(), Gravity.CENTER, 0, 0);
    }

    /**
     * 隐藏加载框
     */
    @Override
    public void hideLoadingPopup() {
        if (loadingPopup != null) {
            loadingPopup.dismiss();
        }
    }

    @Override
    protected void initViews(Bundle savedInstanceState) {
        biaoshi = -1;
        initLoadingPopup();

        line_top.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toLoginOrCenter();
//                if (MyApplication.getApp().isLogin()) {
//                    displayLoadingPopup();
//                    accountClick();
//                } else {
//                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
//                }
            }
        });

        line_shoukuan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    accountClick();
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });
        line_jypwd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    jyPwdClick();
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });
        llAccount.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    WalletActivity.actionStart(getActivity());
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }

            }
        });

        line_zican.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    WalletDetailActivity.actionStart(getmActivity());
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });

        line_ctc.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CTCActivity.show(getActivity());
            }
        });

        line_bibi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    TrustListActivity.show(getActivity());
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });
        line_security.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toLoginOrCenter();
            }
        });
        llOrder.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    MyOrderActivity.actionStart(getActivity(), 0);
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });
        llAds.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    if (MyApplication.realVerified == 1) {
                        WonderfulOkhttpUtils.get().url(UrlFactory.getShangjia())
                                .addHeader("x-auth-token", SharedPreferenceInstance.getInstance().getTOKEN())
                                .build().execute(new StringCallback() {
                            @Override
                            public void onError(Request request, Exception e) {

                            }

                            @Override
                            public void onResponse(String response) {
                                Log.i("miao", "商家认证" + response);
                                try {
                                    JSONObject jsonObject = new JSONObject(response);
                                    int code = jsonObject.optInt("code");
                                    if (code == 0) {
                                        JSONObject jsonObject1 = jsonObject.optJSONObject("data");
                                        int certifiedBusinessStatus = jsonObject1.optInt("certifiedBusinessStatus");
                                        if (certifiedBusinessStatus == 2) {
                                            displayLoadingPopup();
                                            AdsActivity.actionStart(getActivity(), MyApplication.getApp().getCurrentUser().getUsername(), MyApplication.getApp().getCurrentUser().getAvatar());
                                        } else {
                                            WonderfulToastUtils.showToast(getActivity().getResources().getText(R.string.shangjia) + "");
                                        }
                                    } else {
                                        WonderfulToastUtils.showToast(getActivity().getResources().getText(R.string.unknown_error) + "");
                                    }
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        });
                    }
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });
        llSafe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toLoginOrCenter();
            }
        });
        llSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MyApplication.getApp().isLogin()) {
                    displayLoadingPopup();
                    SettingActivity.actionStart(getActivity());
                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
            }
        });
        tvMyPromotionCode.setOnClickListener(this);
        imagebitmap = new ArrayList<>();
        imagebitmap.add(R.drawable.invite1);
        imagebitmap.add(R.drawable.invite2);
        imagebitmap.add(R.drawable.invite3);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        hideLoadingPopup();

    }

    @Override
    public void onStart() {
        super.onStart();
        hideLoadingPopup();
    }


    private void toLoginOrCenter() {
        if (MyApplication.getApp().isLogin()) {
            MyInfoActivity.actionStart(getActivity());
        } else {
            startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
        }
    }

    @Override
    protected void obtainData() {
    }

    @Override
    protected void fillWidget() {
    }

    @Override
    protected void loadData() {
        if (MyApplication.getApp().isLogin()) {
            loginingViewText();
        } else {
            notLoginViewText();
        }
    }

    @Override
    protected void initImmersionBar() {
        super.initImmersionBar();
        if (!isSetTitle) {
            ImmersionBar.setTitleBar(getActivity(), llMyinfo);
            isSetTitle = true;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        loadData();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case LoginActivity.RETURN_LOGIN:
                if (resultCode == Activity.RESULT_OK && getUserVisibleHint() && MyApplication.getApp().isLogin()) {
                    loginingViewText();
                } else if (resultCode == Activity.RESULT_CANCELED) {
                    notLoginViewText();
                }
                break;
            default:
        }
    }

    private void notLoginViewText() {
        try {
            sumCny = 0.00;
            sumUsd = 0.000000;
            tvNickName.setText(getActivity().getResources().getText(R.string.not_logged_in));
            tvLevelOneCount.setText("—");
            tvLevelTwoCount.setText("—");
            tvEstimatedReward.setText("—");
            tvCurrentLevel.setText("—");
            Glide.with(getActivity().getApplicationContext()).load(R.mipmap.icon_default_header).into(ivHeader);
        } catch (Exception e) {

        }
    }

    private void loginingViewText() {
        try {
            presenter.myWallet(getmActivity().getToken());
            presenter.safeSetting(getmActivity().getToken());
            User user = MyApplication.getApp().getCurrentUser();
            tvNickName.setText(user.getUsername());
            tvLevelOneCount.setText(String.valueOf(user.getFirstLevel()));
            tvLevelTwoCount.setText(String.valueOf(user.getSecondLevel()));
            tvCurrentLevel.setText(this.getPartnerNameByCount(user.getFirstLevel()));
            tvEstimatedReward.setText("0");
            if (!WonderfulStringUtils.isEmpty(user.getAvatar())) {
                Glide.with(getActivity().getApplicationContext()).load(user.getAvatar()).into(ivHeader);
            } else {
                Glide.with(getActivity().getApplicationContext()).load(R.mipmap.icon_default_header).into(ivHeader);
            }

            this.presenter.myPromotion(getmActivity().getToken());
        } catch (Exception e) {

        }

    }

    private String getPartnerNameByCount(int count) {
        if (count > 0) {
            return "L1";
        }
        if (count > 10) {
            return "L2";
        }
        if (count > 100) {
            return "L3";
        }
        if (count > 500) {
            return "L4";
        }
        if (count > 1500) {
            return "L5";
        }
        if (count > 3000) {
            return "L6";
        }
        return "L0";
    }

    @Override
    public void setPresenter(MainContract.FivePresenter presenter) {
        this.presenter = presenter;
    }

    @Override
    public void myPromotionSuccess(JSONObject ret) {
        if (ret == null) {
            return;
        }
        try {
            tvEstimatedReward.setText(ret.getString("estimatedReward"));
            tvLevelOneCount.setText(ret.getString("levelOne"));
            tvLevelTwoCount.setText(ret.getString("levelTwo"));
        } catch (JSONException e) {
            tvEstimatedReward.setText("—");
        }
    }

    @Override
    public void myPromotionFail(Integer code, String toastMessage) {
        tvEstimatedReward.setText("-");
    }

    @Override
    public void myWalletSuccess(List<Coin> obj) {
        if (obj == null) {
            return;
        }
        calcuTotal(obj);
    }

    private void calcuTotal(List<Coin> coins) {
        sumUsd = 0;
        sumCny = 0;
        for (Coin coin : coins) {
            sumUsd += (coin.getBalance() * coin.getCoin().getUsdRate());
            sumCny += (coin.getBalance() * coin.getCoin().getCnyRate());
        }
    }

    @Override
    public void myWalletFail(Integer code, String toastMessage) {
//        WonderfulCodeUtils.checkedErrorCode(getmActivity(), code, toastMessage);
        biaoshi = 1;
//        SharedPreferenceInstance.getInstance().saveIsNeedShowLock(false);
//        SharedPreferenceInstance.getInstance().saveLockPwd("");
        MyApplication.getApp().setCurrentUser(null);
        notLoginViewText();
        if (code == 4000) {
//            MyApplication.getApp().loginAgain(getmActivity());
            SharedPreferenceInstance.getInstance().saveaToken("");
            SharedPreferenceInstance.getInstance().saveTOKEN("");
        }
    }

    private void accountClick() {
        if (safeSetting == null) {
            return;
        }
        hideLoadingPopup();
        if (safeSetting.getRealVerified() == 1 && safeSetting.getFundsVerified() == 1) {
            BindAccountActivity.actionStart(getmActivity());
        } else {
            WonderfulToastUtils.showToast(getActivity().getResources().getText(R.string.password_realname) + "");
        }
    }

    public void jyPwdClick() {
        if (safeSetting == null) return;
        if (safeSetting.getFundsVerified() == 0) AccountPwdActivity.actionStart(getmActivity());
        else if (safeSetting.getFundsVerified() == 1)
            EditAccountPwdActivity.actionStart(getmActivity());
    }

    private int biaoshi = -1;

    @Override
    public void safeSettingSuccess(SafeSetting obj) {
        if (obj == null) {
            return;
        }
        this.safeSetting = obj;
        MyApplication.number = safeSetting.getMobilePhone();

//        if (tvIdCredit==null){
//            return;
//        }
//        if (safeSetting.getRealVerified() == 1) {
//            tvIdCredit.setEnabled(false);
//            tvIdCredit.setText(R.string.verification);
//        } else if (safeSetting.getRealAuditing() == 1) {
//            tvIdCredit.setEnabled(false);
//            tvIdCredit.setText(R.string.creditting);
//        } else {
//            tvIdCredit.setEnabled(true);
//            tvIdCredit.setText(R.string.unverified);
//        }
    }

    @Override
    public void safeSettingFail(Integer code, String toastMessage) {
        if (code == 4000) {
            MyApplication.getApp().setCurrentUser(null);
            SharedPreferenceInstance.getInstance().saveaToken("");
            SharedPreferenceInstance.getInstance().saveTOKEN("");
            notLoginViewText();
        }
        //do nothing
    }

    @Override
    protected String getmTag() {
        return TAG;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        unbinder = ButterKnife.bind(this, rootView);
        return rootView;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        unbinder.unbind();
    }
//user.getPromotionCode(), user.getPromotionPrefix()
    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.tvMyPromotionCode:
                if (MyApplication.getApp().isLogin()) {
                    User user = MyApplication.getApp().getCurrentUser();
                    adapter = new shareApkImageAdapter(R.layout.item_pop_five_invite, imagebitmap, user.getPromotionCode(), user.getPromotionPrefix());
                    fivePopInvite = new FivePopInvite(getActivity(),adapter , this);
                    fivePopInvite.showAtLocation(getActivity().findViewById(R.id.llRoot), Gravity.BOTTOM, 0, 0);

                } else {
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), LoginActivity.RETURN_LOGIN);
                }
                break;
            case R.id.tv_copy:
                User user = MyApplication.getApp().getCurrentUser();
                String myInviteLink = user.getPromotionPrefix() + user.getPromotionCode();
                WonderfulCommonUtils.copyText(getActivity(), myInviteLink);
                WonderfulToastUtils.showToast(R.string.copy_success);
                if (fivePopInvite.isShowing()) {
                    fivePopInvite.dismiss();
                }
                break;
            case R.id.tv_save:
//                WonderfulToastUtils.showToast(R.string.savelocally);
                if (fivePopInvite.index == 9) {
                    WonderfulToastUtils.showToast(R.string.posters);
                    return;
                }
                saveImage();
                if (fivePopInvite.isShowing()) {
                    fivePopInvite.dismiss();
                }
                break;
            case R.id.tv_cancel:
                if (fivePopInvite.isShowing()) {
                    fivePopInvite.dismiss();
                }
                break;
        }
    }

    private void saveImage() {
        img.setImageBitmap(selectimage());
        img.setVisibility(View.VISIBLE);
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                try {
                    //创建savephoto类保存图片
                    SavePhoto savePhoto = new SavePhoto(getActivity());
                    savePhoto.SaveBitmapFromView(img, dir);
                    img.setVisibility(View.GONE);
                    WonderfulToastUtils.showToast(R.string.savelocally);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

            }
        }, 50);
    }

    private Bitmap selectimage() {
        int index = fivePopInvite.index;
        User user = MyApplication.getApp().getCurrentUser();
        LayoutInflater inflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View inflate = inflater.inflate(R.layout.item_pop_five_invite, null);
        RelativeLayout rl_img = inflate.findViewById(R.id.rl_img);
        ImageView img = inflate.findViewById(R.id.img);
        ImageView iv_code_address = inflate.findViewById(R.id.iv_code_address);
        iv_code_address.setImageBitmap(createQRCodeBitmap(user.getPromotionPrefix()+user.getPromotionCode(), 150, 150, "UTF-8", "H", "1", Color.BLACK, Color.WHITE));
        switch (index) {
            case 0:
                img.setImageResource(R.drawable.invite1);
                break;
            case 1:
                img.setImageResource(R.drawable.invite2);
                break;
            case 2:
                img.setImageResource(R.drawable.invite3);
                break;
            default:
                WonderfulToastUtils.showToast(R.string.posters);
                break;
        }
        return generatBitmap(rl_img);
    }

    /**
     * @param relativeLayout 要转化为图片的布局
     */
    private static Bitmap generatBitmap(RelativeLayout relativeLayout) {
        relativeLayout.setDrawingCacheEnabled(true);
        relativeLayout.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED),
                View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
        relativeLayout.layout(0, 0, relativeLayout.getMeasuredWidth(), relativeLayout.getMeasuredHeight());
        relativeLayout.buildDrawingCache();
        Bitmap bitmap = Bitmap.createBitmap(relativeLayout.getDrawingCache());
        relativeLayout.setDrawingCacheEnabled(false);
        relativeLayout.setGravity(Gravity.BOTTOM);//因为刚刚重新测量布局一次，需要重新设置view最x

        return bitmap;
    }

    public Bitmap createQRCodeBitmap(String content, int width, int height,
                                     String character_set, String error_correction_level,
                                     String margin, int color_black, int color_white) {
        // 字符串内容判空
        if (TextUtils.isEmpty(content)) {
            return null;
        }
        // 宽和高>=0
        if (width < 0 || height < 0) {
            return null;
        }
        try {
            /** 1.设置二维码相关配置 */
            Hashtable<EncodeHintType, String> hints = new Hashtable<>();
            // 字符转码格式设置
            if (!TextUtils.isEmpty(character_set)) {
                hints.put(EncodeHintType.CHARACTER_SET, character_set);
            }
            // 容错率设置
            if (!TextUtils.isEmpty(error_correction_level)) {
                hints.put(EncodeHintType.ERROR_CORRECTION, error_correction_level);
            }
            // 空白边距设置
            if (!TextUtils.isEmpty(margin)) {
                hints.put(EncodeHintType.MARGIN, margin);
            }
            /** 2.将配置参数传入到QRCodeWriter的encode方法生成BitMatrix(位矩阵)对象 */
            BitMatrix bitMatrix = new QRCodeWriter().encode(content, BarcodeFormat.QR_CODE, width, height, hints);

            /** 3.创建像素数组,并根据BitMatrix(位矩阵)对象为数组元素赋颜色值 */
            int[] pixels = new int[width * height];
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    //bitMatrix.get(x,y)方法返回true是黑色色块，false是白色色块
                    if (bitMatrix.get(x, y)) {
                        pixels[y * width + x] = color_black;//黑色色块像素设置
                    } else {
                        pixels[y * width + x] = color_white;// 白色色块像素设置
                    }
                }
            }
            /** 4.创建Bitmap对象,根据像素数组设置Bitmap每个像素点的颜色值,并返回Bitmap对象 */
            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            bitmap.setPixels(pixels, 0, width, 0, 0, width, height);
            return bitmap;
        } catch (WriterException e) {
            e.printStackTrace();
            return null;
        }
    }
}
