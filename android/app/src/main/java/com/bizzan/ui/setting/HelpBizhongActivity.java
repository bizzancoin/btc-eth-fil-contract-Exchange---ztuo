package com.bizzan.ui.setting;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.LinearLayout;

import com.bizzan.utils.SharedPreferenceInstance;
import com.gyf.barlibrary.ImmersionBar;
import com.bizzan.R;
import com.bizzan.ui.message_detail.MessageHelpActivity;
import com.bizzan.adapter.GongGaoAdapter;
import com.bizzan.base.BaseActivity;
import com.bizzan.base.LinListView;
import com.bizzan.entity.Message;
import com.bizzan.app.UrlFactory;
import com.bizzan.utils.WonderfulLogUtils;
import com.bizzan.utils.okhttp.StringCallback;
import com.bizzan.utils.okhttp.WonderfulOkhttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import okhttp3.Request;

/**
 * Created by Administrator on 2018/8/9.
 */
public class HelpBizhongActivity extends BaseActivity {
    @BindView(R.id.llTitle)
    LinearLayout llTitle;
    private GongGaoAdapter adapter;
    @BindView(R.id.listview_bizhong)
    LinListView listview_bizhong;
    @BindView(R.id.ibBack)
    ImageButton ibBack;
    private int page = 1;
    @BindView(R.id.view_back)
    View view_back;

    @Override
    protected int getActivityLayoutId() {
        return R.layout.activity_help_bizhong;
    }

    public static void actionStart(Context context) {
        Intent intent = new Intent(context, HelpBizhongActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void initViews(Bundle savedInstanceState) {
        ibBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        view_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        listview_bizhong.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                MessageHelpActivity.actionStart(HelpBizhongActivity.this, messageList.get(position).getId());
            }
        });
    }

    @Override
    protected void obtainData() {

    }

    @Override
    protected void fillWidget() {

    }

    @Override
    protected void loadData() {
        displayLoadingPopup();
        getMessage();
    }

    private void getMessage() {
        int code = SharedPreferenceInstance.getInstance().getLanguageCode();
        String lang = "en_US";
        switch (code) {
            case -1:
                lang = "zh_HK";
                break;
            case 1:
                lang = "zh_CN";
                break;
            case 2:
                lang = "en_US";
                break;
            case 3:
                lang = "ja_JP";
                break;
            case 4:
                lang = "ko_KR";
                break;
            case 5:
                lang = "de_DE";
                break;
            case 6:
                lang = "fr_FR";
                break;
            case 7:
                lang = "it_IT";
                break;
            case 8:
                lang = "es_ES";
                break;
        }
        WonderfulOkhttpUtils.post().url(UrlFactory.getHelpXinShou())
                .addParams("cate", "3")
                .addParams("lang", lang)
                .addParams("pageNo", page + "")
                .addParams("pageSize", "20")
                .build().execute(new StringCallback() {
            @Override
            public void onError(Request request, Exception e) {
                hideLoadingPopup();
                listview_bizhong.stopFreshing();
            }

            @Override
            public void onResponse(String response) {
                WonderfulLogUtils.logi("miao", response);
                hideLoadingPopup();
                listview_bizhong.stopFreshing();
                if (listview_bizhong==null){
                    return;
                }
                try {
                    JSONObject object = new JSONObject(response);
                    JSONObject jsonObject2 = object.optJSONObject("data");
                    JSONArray jsonArray1 = jsonObject2.optJSONArray("content");
                    if (jsonArray1.length() > 0) {
                        for (int i = 0; i < jsonArray1.length(); i++) {
                            JSONObject jsonObject1 = jsonArray1.optJSONObject(i);
                            Message bean = new Message();
                            bean.setContent(jsonObject1.optString("content"));
                            bean.setCreateTime(jsonObject1.optString("createTime"));
                            bean.setIsTop(jsonObject1.optString("isTop"));
                            bean.setId(jsonObject1.optString("id"));
                            bean.setTitle(jsonObject1.optString("title"));
                            messageList.add(bean);
                        }
                        adapter = new GongGaoAdapter(HelpBizhongActivity.this, messageList);
                        listview_bizhong.setEveryPageItemCount(20);
                        listview_bizhong.setAdapter(adapter);
                        listview_bizhong.setOnRefreshListener(new LinListView.OnRefreshListener() {
                            @Override
                            public void onLoadMore() {
                                page=page+1;
                                getMessage();
                            }

                            @Override
                            public void onRefresh() {
                                messageList.clear();
                                page=1;
                                getMessage();
                            }
                        });
                        adapter.notifyDataSetChanged();
                    }


//                        adapter=new GongGaoAdapter(HelpActivity.this,messageList);
//
//                        listview_xinshou.setAdapter(adapter);
//                        adapter.notifyDataSetChanged();


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
//        marqueeView.setOnItemClickListener(new MarqueeView.OnItemClickListener() {
//            @Override
//            public void onItemClick(int position, TextView textView) {
//                MessageDetailActivity.actionStart(getActivity(), messageList.get(infoss.get(position)).getId());
//            }
//        });
    }

    private List<Message> messageList = new ArrayList<>();

    @Override
    protected void initImmersionBar() {
        super.initImmersionBar();
        if (!isSetTitle) {
            ImmersionBar.setTitleBar(HelpBizhongActivity.this, llTitle);
            isSetTitle = true;
        }
    }

}
