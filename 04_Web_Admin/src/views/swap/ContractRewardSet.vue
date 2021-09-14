<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
        返佣比例
		<Button size="small" type="primary" @click="toCopy(rebateSet.name)" >复制用户电话{{rebateSet.name}}</Button>
		<Button size="small" type="primary" @click="toCopy(rebateSet.realName)" >复制用户姓名{{rebateSet.realName}}</Button>
        <Button type="primary" size="small" @click="clearAndRef">
          <Icon type="refresh"></Icon>清除缓存刷新
        </Button>
      
      <!-- <div id="myChart" style="width: 1600px;height:800px;"></div> -->
     <button type="button" @click="toggle" >全屏</button>
     <fullscreen ref="fullscreen" @change="fullscreenChange" background="#EEE">
           <div id="myChart" :class="!fullscreen?'no-full-style':'full-style'"></div>
     </fullscreen>
    </Card>
 </div>
</template>


 <script>
import dtime from 'time-formater';
import { queryRewardSetList,clearRewardSet } from '@/service/getData';
var myChart =null;

export default {
  data () {
      return {
       fullscreen: false,
       rebateSet:{
       		  rate:"",
       		  id:"",
       		  name:"",
       		  realName:"",
       		  canUpdate:false
       },
      }
    },
    mounted () {
      this.drawLine();
    },
    methods: {
		toggle() {
		        this.$refs['fullscreen'].toggle() // recommended
		        // this.fullscreen = !this.fullscreen // deprecated
		      },
		fullscreenChange (fullscreen) {
		  this.fullscreen = fullscreen;
		  this.$nextTick(() => {
		          myChart.resize()
		        })
		},
		clearAndRef(){
			clearRewardSet().then(res =>{
				this.drawLine();
			});
		},
		open(params){
		  this.rebateSet=params.data;
		  this.rebateSet.rate = this.rebateSet.rate.replace('%',"");
		},
		toCopy(text){
		  if (!text) {
			  this.$Notice.error({
			          title: "请先选择用户",
			          desc: "请先选择用户",
			          duration: 10
			      });
		  } else {
			  var copyInput = document.createElement('input')
			  copyInput.setAttribute('value', text)
			  document.body.appendChild(copyInput)
			  copyInput.select()

			  try {
				  var copyed = document.execCommand('copy')
				  if (copyed) {
					  document.body.removeChild(copyInput)
					  this.$Notice.success({
					          title: "复制成功",
					          desc: "复制成功",
					          duration: 10
					      });
				  }
			  } catch(e){
				  this.$Notice.error({
				          title: "复制失败",
				          desc: "复制失败，请检查浏览器兼容",
				          duration: 10
				      });
			  }
		  }
		},
		drawLine () {
        var echarts = require('echarts');
        myChart = echarts.init(document.getElementById('myChart'));
		myChart.hideLoading();
		var dialogV = this;
		queryRewardSetList().then(res => {
		  let data = res.data;
		  let option = {
			  tooltip: {
				  trigger: 'item',
				  triggerOn: 'mousemove',
				  formatter:(params) =>{
				  	 let lab = params.data.name;
				  	 if(params.data.rate!=""){
				  		 lab = lab + ":" + params.data.rate;
				  	 }
				  	 return lab;
				  }
			  },
			  series: [
				  {
					type:'tree',
					roam: true,
					data: [data],
					top: '1%',
					left: '7%',
					bottom: '1%',
					right: '20%',
					symbolSize: 15,
					label: {
						 position: 'left',
						 verticalAlign: 'middle',
						 align: 'right',
						 fontSize: 15,
						 formatter:(params) =>{ 
							 let lab = params.data.realName;
							 if(params.data.rate!=""){
							 	lab = lab + ":" + params.data.rate;
							 }
							 return lab;
						}
					},
					leaves: {
						 label: {
							 position: 'right',
							 verticalAlign: 'middle',
							 align: 'left',
							 fontSize: 15,
						 }
					},
					expandAndCollapse: true,
					animationDuration: 550,
					animationDurationUpdate: 750
				  }
			  ]
		  };
		  myChart.setOption(option);
		  myChart.on('click', function (params) {
		  	dialogV.open(params);
		  });
		});
      }
    }
  }
</script>
<style scoped>
.no-full-style {
  width: 1800px;
  height: 800px;
}
.full-style {
  width: 100%;
  height: 100%;
}
</style>