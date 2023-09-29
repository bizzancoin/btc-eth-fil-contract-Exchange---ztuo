<template>
  <div>
    <!-- 面包屑导航 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>返佣设置</el-breadcrumb-item>
    </el-breadcrumb>
   <el-form :inline="true" class="user-search">
     
     <el-form-item>
		<el-button size="small" type="primary" @click="toCopy(rebateSet.name)" >复制用户电话{{rebateSet.name}}</el-button>
		<el-button size="small" type="primary" @click="toCopy(rebateSet.realName)" >复制用户姓名{{rebateSet.realName}}</el-button>
       <el-button size="small" type="primary" icon="el-icon-refresh" @click="clearAndRef" >清除缓存</el-button>
	   <el-button size="small" type="primary" @click="toggle" >全屏</el-button>
     </el-form-item>

   </el-form>
   <el-dialog title="修改比例" :visible.sync="dialogVisible">
     <el-form :model="rebateSet" status-icon :rules="rules" ref="rebateSet" label-width="100px" class="demo-ruleForm">
       <el-form-item label="用户" prop="name">
         <el-input type="text" disabled v-model="rebateSet.name" autocomplete="off"></el-input>
       </el-form-item>
       <el-form-item label="比例" prop="rate">
         <el-input max="100" min="0" type="number" v-model.number="rebateSet.rate">
			<template slot="append">%</template>
		 </el-input>
       </el-form-item>
     </el-form>
     <span slot="footer" class="dialog-footer">
       <el-button @click="dialogVisible = false">取 消</el-button>
       <el-button type="primary" @click="submitForm('rebateSet')">确 定</el-button>
     </span>
   </el-dialog>
   
   <fullscreen ref="fullscreen" @change="fullscreenChange" background="#EEE">
         <div id="main" :class="!fullscreen?'no-full-style':'full-style'"></div>
   </fullscreen>
	
  </div>
</template>

<script>
import {getTransactionRebateSet,clearTransactionRebateSet,transactionRebateSet} from '../../api/api';
var myChart =null;
export default {
  name: 'FuncFormsBase',
  data () {
	  var checkAge = (rule, value, callback) => {
	          if (!value) {
	            return callback(new Error('比例不能为空'));
	          }
	          setTimeout(() => {
				  if (value < 0 || value >100) {
					callback(new Error('请输入0~100之间的数字值'));
				  } else {
					callback();
				  }
	          }, 1000);
	        };
    return {
	  fullscreen: false,
      dialogVisible: false,
	  rebateSet:{
		  rate:"",
		  id:"",
		  name:"",
		  realName:"",
		  canUpdate:false
	  },
	  rules: {
			rate: [
			  { validator: checkAge, trigger: 'blur' }
			]
		  }
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
	  	clearTransactionRebateSet().then(res =>{
	  		this.drawLine();
	  	});
	  },
	submitForm(formName) {
		
		this.$refs[formName].validate((valid) => {
		  if (valid) {
			transactionRebateSet(this.rebateSet).then(res=>{
				if(res.code == 0) {
					this.dialogVisible=false;
					this.drawLine();
				}else{
				  this.$message.error(res.message);
				}
			});
		  } else {
			return false;
		  }
		});
		
	  },
	  resetForm(formName) {
		this.$refs[formName].resetFields();
	  },
	  open(params){
		  this.rebateSet=params.data;
		  if(this.rebateSet.canUpdate){
			  this.dialogVisible=true;
			  this.$refs['fullscreen'].exit();
		  }else{
			  this.$message.error("没有权限修改");
		  }
		  this.rebateSet.rate = this.rebateSet.rate.replace('%',"");
	  },
	  toCopy(text){
		  if (!text) {
			  this.$message.error('请先选择用户')
		  } else {
			  var copyInput = document.createElement('input')
			  copyInput.setAttribute('value', text)
			  document.body.appendChild(copyInput)
			  copyInput.select()

			  try {
				  var copyed = document.execCommand('copy')
				  if (copyed) {
					  document.body.removeChild(copyInput)
					  this.$message.success('复制成功')
				  }
			  } catch(e){
				  this.$message.error('复制失败，请检查浏览器兼容')
			  }
		  }
	  },
    drawLine () {
      var echarts = require('echarts');
      myChart = echarts.init(document.getElementById('main'));
	  var dialogV = this;
	  myChart.hideLoading();
	  getTransactionRebateSet().then((res) => {
		if(res.code == 0) {
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
						type: 'tree',
						roam: true,
						data: [data],
						
						top: '1%',
						left: '7%',
						bottom: '1%',
						right: '20%',
		  
						symbolSize: 20,
						
						label: {
							position: 'left',
							verticalAlign: 'middle',
							align: 'right',
							fontSize: 20,
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
								fontSize: 20
							}
						},
		  
						expandAndCollapse: false,
						animationDuration: 550,
						animationDurationUpdate: 750
					}
				]
			};
			myChart.setOption(option);
			myChart.on('click', function (params) {
				dialogV.open(params);
			});
		} else{
		  this.$message.error(res.message);
		}
	  });	  
    }
  }
}
</script>

<style scoped>
</style>


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




