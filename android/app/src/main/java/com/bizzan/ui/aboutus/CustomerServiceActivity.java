package com.bizzan.ui.aboutus;

import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.bizzan.R;
import com.bizzan.base.BaseActivity;
import com.gyf.barlibrary.ImmersionBar;

import butterknife.BindView;
import butterknife.OnClick;

public class CustomerServiceActivity extends BaseActivity {

    @BindView(R.id.wb)
    WebView wb;

    @BindView(R.id.rlTitle)
    RelativeLayout rlTitle;

    private String url = "https://auto-sim-zk.com/index.php/huoma/duo?d=od437gwqw";

    @Override
    protected int getActivityLayoutId() {
        return R.layout.activity_customer_service;
    }


    @Override
    protected void initViews(Bundle savedInstanceState) {
        initWb();
    }

    private void initWb() {
        wb.getSettings().setJavaScriptEnabled(true);
        wb.getSettings().setSupportZoom(false);
        wb.getSettings().setBuiltInZoomControls(false);
//        wb.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN);
        wb.getSettings().setDefaultFontSize(14);
        wb.setWebViewClient(new WebViewClient());

        wb.loadUrl(url);
    }


    @Override
    protected void obtainData() {

    }

    @Override
    protected void fillWidget() {

    }

    @Override
    protected void loadData() {

    }

    @OnClick(R.id.ibBack)
    public void onViewClicked() {
        finish();
    }

    @Override
    protected void initImmersionBar() {
        super.initImmersionBar();
        if (!isSetTitle) {
            ImmersionBar.setTitleBar(this, rlTitle);
            isSetTitle = true;
        }
    }
}
