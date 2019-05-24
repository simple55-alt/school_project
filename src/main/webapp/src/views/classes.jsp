<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String path = request.getContextPath();
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/src/layuiadmin/layui/css/layui.css"
	media="all">
<title>班级</title>
</head>
<body>
	<table id="classList" lay-filter="test"></table>
	
	<script type="text/html" id="topToolBar">
		<div class="layui-inline">
			<input class="layui-input" name="classId" id="classId" placeholder="班级ID" autocomplete="off">
		</div>
		<div class="layui-inline">
			<input class="layui-input" name="className" id="className" placeholder="班级名称" autocomplete="off">
		</div>
		<div class="layui-btn-group">
			<button class="layui-btn" lay-event="search">搜索</button>
			<button class="layui-btn" lay-event="add">添加</button>
			<button class="layui-btn" lay-event="multiDelete">删除</button>
		</div>
	</script>
	<script type="text/html" id="barDemo">
  		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
 		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	
	<script src="${pageContext.request.contextPath}/src/layuiadmin/layui/layui.js"></script>
	<script type="text/javascript">
		<%-- <%=basePath%> 可以获取到含端口号的url--%>
		layui.use(['table', 'jquery', 'layer'], function() {
			var table = layui.table, $ = layui.jquery, layer = layui.layer;
			table.render({
				elem: '#classList',
				url: '${pageContext.request.contextPath}/classes/selClass.action',
				method: 'post',
				page: true,
				toolbar: '#topToolBar',
				cols: [[
			        {
			        	type: 'checkbox',
			        	fixed: 'left',
			        },
			        {
						field : 'id',
						title : '班级id',
						sort : true,
						align: 'center',
					},
					{
						field: 'className',
						title: '班级名称',
						align: 'center'
					},
					{
						field : 'edit',
						title : '操作',
						align : 'center',
						toolbar: '#barDemo',
						fixed: 'right',
					}
		        ]] // cols
			}) // table.render
			
			// 头部事件处理
			table.on('toolbar(test)', function(obj){
				var event = obj.event;
			    if (event === 'search') {
			    	table.reload('classList', {
						url: '${pageContext.request.contextPath}/classes/selClass.action',
		    		    where: {
							id: $('#classId').val() || 0,
		    			    className: $('#className').val() || null
		    		    },
		    		    page: { curr: 1  }
					});
			    } else if (event === 'multiDelete') {
			    	if (ids.length === 0) {
			    		return;
			    	} else {
			    		layer.confirm('确认删除？', function(index) {
			    			table.reload('classList', {
								url: '${pageContext.request.contextPath}/classes/delClass.action',
				    		    where: { ids: ids },
				    		    page: { curr: 1  }
							});
			    			layer.close(index);
			    		})
					}
			    } else if(event === 'add') {
			    	layer.prompt({
			  			formType: 0,
						title : '请添加班级名称：',
						area : [ '800px', '350px' ]
						//自定义文本域宽高
						}, function( value, index, elem) {
								table.reload('classList', {
									url : '${pageContext.request.contextPath}/classes/addClass.action',
									where : { className : value }
								});
								layer.close(index);
						}
					);
			    }
			}); // table.on
			
			// 行内工具栏事件
			table.on('tool(test)', function(obj){ // test是table原始容器的属性 lay-filter="对应的值"
				  var data = obj.data; // 获得当前行数据
				  var event = obj.event; // 获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				  if (event === 'del') {
					  layer.confirm('确认删除？', function(index){
						  table.reload('classList', {
								url : '${pageContext.request.contextPath}/classes/delClass.action',
								where : { id: data.id }
							});
					      layer.close(index);
				    	});
				  	} else if (event === 'edit') {
				  		layer.prompt({
				  			formType: 0,
							value : data.className,
							title : '请编辑：',
							area : [ '800px', '350px' ]
							//自定义文本域宽高
							}, function( value, index, elem) {
									table.reload('classList', {
										url : '${pageContext.request.contextPath}/classes/addClass.action',
										where : {
											id : data.id,
											className : value
										}
									});
									layer.close(index);
							}
						);
				  	}
			}); // table.on
			
			var ids = '';
			// 复选框事件
			table.on('checkbox(test)', function(obj){ 
				var checkStatus = table.checkStatus('classList'); // 获取所有选中行的相关信息
				var data = checkStatus.data;
				ids = '';
				data.forEach(function(item) {
					ids += item.id + ',';
				})
			});
			
		}) // layui.use
	</script>
</body>
</html>