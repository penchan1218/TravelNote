 (function() {
  var MODEL_1 = function() {
		//参数说明：（模板界面编号, {title: "page标题（内容中）, content:"正文", img: "图片地址", alt:"可有可无"}）
		function add_page (page_num, page_data, callback) {
  var dom = document.createDocumentFragment();
  
  for (var i=0; i < page_num.length; i++) {
  
  var dom_part = $(templates[page_num[i]](page_data[i]))[0];
  dom.appendChild(dom_part);
  }
  
  $(".swiper-wrapper").append(dom);
  
  if (arguments.length == 3) {
  callback();
  }
		}
  
		function template_format (template, f_data){
  for (var i in f_data) {
  template = template.replace(i, f_data[i]);
  }
  
  return template;
		}
  
		//这里定义了所有的模板  第一个参数就是模板，
		var templates =  {
  //page1 需要的参数是 title、content、user_img
  "1": function(data, letter_per_col) {
  
  var letter_per_col = (typeof letter_per_col == "undefined")?6:letter_per_col;
  
  var text =  "<div class='my-model-1 my-m1p1 my-model-out swiper-slide'>\
  <div class='my-m1p1-cover' >\
  <div class='my-m1p1-text'>\
  <div class='my-m1p1-title'><p>$title</p></div>\
  $text\
  </div>\
  </div>\
  <div class='my-m1p1-img my-m1p1-img-h'><img data-src='$user_img' class='swiper-lazy' page-num='1'></div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>";
  
  function format(data, letter_per_col) {
  var cont = data["text"];
  
  var content = "";
  console.log(data);
  for (var i=0; i < cont.length; i += letter_per_col) {
  if (cont.slice(i) == "") return;
  content += "<span>"+cont.slice(i, i+letter_per_col)+"</span>";
  }
  
  var f_data = {
  "$title": data["title"],
  "$text": content,
  "$user_img": data["user_img"],
  }
  
  return template_format(text, f_data);
  }
  
  return format(data, letter_per_col);
  
  },
  //page2 需要的参数是user_img title user_name 页面二应该算是一个封面了吧
  "2": function (data) {
  var text = "<div class='my-model-1 my-m1p2 swiper-slide my-model-out'>\
  <div class='my-m1p2-container'>\
  <div class='my-m1p2-cover'>\
  </div>\
  <div class='my-m1p2-img my-m1p2-img-h'>\
  <img data-src='$user_img' class='swiper-lazy' page-num='2'/>\
  </div>\
  <div class='my-m1p2-content'>\
  <h5>$title</h5>\
  <h6>by $user_name</h6>\
  <img class='my-m1p2-arrow' src='/images/model1/2/arrow.png'></img>\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  
  var f_data = {
  "$user_name": data["user_name"],
  "$title": data["title"],
  "$user_img": data["user_img"]
  }
  return template_format(text, f_data);
  },
  //page3 需要的参数是 text user_img
  "3": function(data) {
  var text = "<div class='my-model-1 my-m1p3 swiper-slide my-model-out'>\
  <div class='my-m1p3-container'>\
  <div class='my-m1p3-cover'>\
  <img src='/images/model1/3/icon.png' class='my-m1p3-pattern'>\
  <div class='my-m1p3-text'><p>$text</p></div>\
  </div>\
  <div class='my-m1p3-img my-m1p3-img-h'>\
  <img data-src='$user_img' class='swiper-lazy' page-num='3'>\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  
  var f_data = {
  "$text": data["text"],
  "$user_img": data["user_img"]
  }
  return template_format(text, f_data);
  },
  //page4 需要的参数是text user_img
  "4": function(data, letter_per_col) {
  var letter_per_col = (typeof letter_per_col == "undefined")?6:letter_per_col;
  var text = "<div class='my-model-1 my-m1p4 swiper-slide my-model-out'>\
  <div class='my-m1p4-container'>\
  <div class='my-m1p4-cover'>\
  <div class='my-m1p4-text'>\
  $text\
  </div>\
  </div>\
  <div class='my-m1p4-img my-m1p4-img-h'>\
  <img data-src='$user_img' class='swiper-lazy' page-num='4'>\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  function format(data, letter_per_col) {
  
  var cont = data["text"];
  
  var content = "";
  
  for (var i=0; i < cont.length; i += letter_per_col) {
  if (cont.slice(i) == "") return;
  content += "<span>"+cont.slice(i, i+letter_per_col)+"</span>";
  }
  
  var f_data = {
  "$text": content,
  "$user_img": data["user_img"],
  }
  
  return template_format(text, f_data);
  }
  
  return format(data, letter_per_col);
  },
  "5": function(data, letter_per_col) {
  var letter_per_col = (typeof letter_per_col == "undefined")?5:letter_per_col;
  var text = "<div class='my-model-1 my-m1p5 swiper-slide my-model-out'>\
  <div class='my-m1p5-container'>\
  <div class='my-m1p5-cover'>\
  <div class='my-m1p5-outer'></div>\
  <div class='my-m1p5-img my-m1p5-img-h'>\
  <img data-src='$user_img' class='swiper-lazy' page-num='5'>\
  </div>\
  </div>\
  <div class='my-m1p5-text'>\
  <div>\
  $text\
  </div>\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  function format(data, letter_per_col) {
  
  var cont = data["text"];
  
  var content = "";
  
  for (var i=0; i < cont.length; i += letter_per_col) {
  if (cont.slice(i) == "") return;
  content += "<span>"+cont.slice(i, i+letter_per_col)+"</span>";
  }
  
  var f_data = {
  "$text": content,
  "$user_img": data["user_img"],
  }
  
  return template_format(text, f_data);
  }
  return format(data, letter_per_col);
  },
  "6": function(data) {
  var text = "<div class='my-model-1 my-m1p6 swiper-slide my-model-out'>\
  <div class='my-m1p6-container'>\
  <div class='my-m1p6-cover'>\
  <div class='my-m1p6-outer'></div>\
  <div class='my-m1p6-img my-m1p6-img-h'>\
  <img data-src='$user_img' class='swiper-lazy' page-num='6'>\
  </div>\
  </div>\
  <div class='my-m1p6-text'>\
  <p>$text</p>\
  <hr>\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  var f_data = {
  "$text": data["text"],
  "$user_img": data["user_img"]
  }
  return template_format(text, f_data);
  },
  "7": function(data, letter_per_col) {
  var letter_per_col = (typeof letter_per_col == "undefined")?5:letter_per_col;
  var text = "<div class='my-model-1 my-m1p7 swiper-slide my-model-out'>\
  <div class='my-m1p7-container'>\
  <div class='my-m1p7-cover'>\
  <div class='my-m1p7-outer'></div>\
  <div class='my-m1p7-img my-m1p7-img-h'>\
  <img data-src='$user_img' class='swiper-lazy' page-num='7'>\
  </div>\
  </div>\
  <div class='my-m1p7-text'>\
  $text\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  function format(data, letter_per_col) {
  var cont = data["text"];
  
  var content = "";
  
  for (var i=0; i < cont.length; i += letter_per_col) {
  if (cont.slice(i) == "") return;
  content += "<span>"+cont.slice(i, i+letter_per_col)+"</span>";
  }
  
  var f_data = {
  "$text": content,
  "$user_img": data["user_img"],
  }
  
  return template_format(text, f_data);
  }
  return format(data, letter_per_col);
  },
  "8": function(data, letter_per_col) {
  var letter_per_col = (typeof letter_per_col == "undefined")?7:letter_per_col;
  var text = "<div class='my-model-1 my-m1p8 swiper-slide my-model-out'>\
  <div class='my-m1p8-container'>\
  <div class='my-m1p8-cover'>\
  <div class='my-m1p8-outer'></div>\
  <div class='my-m1p8-img my-m1p8-img-h'><img data-src='$user_img' class='swiper-lazy' page-num='8'></div>\
  <div class='my-m1p8-text'>$text</div>\
  </div>\
  <div class='swiper-lazy-preloader'></div>\
  </div>\
  </div>";
  
  function format(data, letter_per_col) {
  var cont = data["text"];
  
  var content = "";
  
  for (var i=0; i < cont.length; i += letter_per_col) {
  if (cont.slice(i) == "") return;
  content += "<span>"+cont.slice(i, i+letter_per_col)+"</span>";
  }
  
  var f_data = {
  "$text": content,
  "$user_img": data["user_img"],
  }
  
  return template_format(text, f_data);
  }
  return format(data, letter_per_col);
  }
		}
		
		this.add_page = add_page;
  }
  
  // var domain = "http://120.26.129.111";
  var domain = "";
  var model = new MODEL_1();
  var getImgPath = function (key) {
		return domain+"/api/img?Key="+key;
  }
  var inited = false;
  
  var init = function (model, article_id) {
		$.ajax({
               "url": domain+"/api/getArticle?articleId="+article_id,
               "type": "GET",
               "dataType": "json",
               "success": function(data) {
               if (data.success) {
               console.log("all api data", data);
               var title = data.article.title;
               var nickName = data.article.user.nickname;
               var coverKey = data.article.coverKey;
               var content = data.article.content;
               
               var pageArr = ["2"];
               var contentArr = [{"title": title, "user_img": getImgPath(coverKey), "user_name": nickName}];
               
               for(var i=0; i < content.length; i++) {
               var pageNum;
               
               if (i+1 > 8) {
               pageNum = Math.round(Math.random()*8);
               }
               else {
               pageNum = i+1;
               }
               
               if (pageNum == 2) {
               pageNum = 7;
               }
               
               pageArr.push(""+pageNum);
               contentArr.push({"title": title, "user_img": getImgPath(content[i].picKey), "text": content[i].intro});
               }
               
               model.add_page(pageArr, contentArr, function(){
                              $(".swiper-container").swiper({
                                                            preloadImage: false,
                                                            lazyLoading: true,
                                                            lazyLoadingInPrevNext: true,
                                                            spaceBetween: 10,
                                                            direction: "vertical",
                                                            autoplay: 9000,
                                                            autoplayDisableOnInteraction: false,
                                                            onInit: function() {
                                                            inited = true;
                                                            },
                                                            onLazyImageLoad: function(swiper, slide, image) {
                                                            
                                                            //这里作一下横竖图片的适配
                                                            $(image).bind("load", function(){
                                                                          var ratio = image.width/image.height;
                                                                          var page_num = $(image).attr("page-num");
                                                                          if (ratio < 1) {
                                                                          $(image).parent().removeClass("my-m1p"+page_num+"-img-h").addClass("my-m1p"+page_num+"-img-v");
                                                                          }
                                                                          });
                                                            },
                                                            onTransitionEnd: function(swiper) {
                                                            $(".swiper-slide-active").removeClass("my-model-out");
                                                            }
                                                            });
                              });
               }
               else {
               console.log("get data failed");
               }
               },
               "error": function(data) {
               console.log(data);
               }
               });
  }
  testInit = function(data) {
		/*
         data中的数据是
         {
         "title": "",
         "nickName": "用户的昵称",
         "coverImg": "封面图片",
         "contents": [] // 内容数组， 一个json数组{"text": "", "userImg", ""}
         }
         */
		var data  = eval("("+data+")");
		var title = data.title;
		var nickName = data.nickName;
		var coverImg = data.coverImg;
		var contents = data.contents;
  
		var pageArr = ["2"];
		var contentArr = [{"title": title, "user_img": coverImg, "user_name": nickName}];
  
		for(var i=0; i < contents.length; i++) {
  var pageNum;
  
  if (i+1 > 8) {
  pageNum = Math.round(Math.random()*8);
  }
  else {
  pageNum = i+1;
  }
  
  if (pageNum == 2) {
  pageNum = 7;
  }
  
  pageArr.push(""+pageNum);
  contentArr.push({"title": title, "user_img": contents[i].userImg, "text": contents[i].text});
		}
		model.add_page(pageArr, contentArr, function(){
                       $(".swiper-container").swiper({
                                                     preloadImage: false,
                                                     lazyLoading: true,
                                                     lazyLoadingInPrevNext: true,
                                                     spaceBetween: 10,
                                                     direction: "vertical",
                                                     autoplay: 9000,
                                                     autoplayDisableOnInteraction: false,
                                                     onInit: function() {
                                                     inited = true;
                                                     },
                                                     onLazyImageLoad: function(swiper, slide, image) {
                                                     
                                                     //这里作一下横竖图片的适配
                                                     $(image).bind("load", function(){
                                                                   var ratio = image.width/image.height;
                                                                   var page_num = $(image).attr("page-num");
                                                                   if (ratio < 1) {
                                                                   $(image).parent().removeClass("my-m1p"+page_num+"-img-h").addClass("my-m1p"+page_num+"-img-v");
                                                                   }
                                                                   });
                                                     },
                                                     onTransitionEnd: function(swiper) {
                                                     $(".swiper-slide-active").removeClass("my-model-out");
                                                     }
                                                     });
                       });
  }
  window.addEventListener("load", function(){
                          var interval = setInterval(function() {
                                                     if (inited) {
                                                     clearInterval(interval);
                                                     $(".my-model-loading").css("display", "none");
                                                     $(".swiper-slide-active").removeClass("my-model-out");
                                                     }
                                                     }, 200);
                          });
  // 测试
//   var contentArr = [
//   		{
//   			"text":"在伊斯坦布尔遇见了很多不同的人，有趣的事，这是一个幸福的地方我会再来的。", 
//   			"userImg":"1.jpg"
//   		},
//   		{
//   			"text":"一个人飞往伊斯坦布尔，第一次去这么远的地方。",
//   			"userImg": "3.jpg"
//   		},
//   		{
//   			"userImg": "4.jpg",
//   			"text": "这家酒店非常不错，观景台的视角非常好，大早上起床爬上来感觉呼吸都是美的。"
//   		},
//   		{
//   			"userImg": "5.jpg", 
//   			"text": "在城堡的议事厅里面，这里应该是国王以前议事的地方。"
//   		}, 
//   		{
//   			"text": "在格雷梅自驾是一种特别的享受，听着音乐一路感受沿途的风景~",
//   			"userImg": "6.jpg"
//   		}, 
//   		{
//   			"text":"快日落的时，我们赶去玫瑰谷，夕阳正好打在脸上，拍照的好时机。", 
//   			"userImg": "7.jpg"
//   		},
//   		{
//   			"text":"来到海边的第二天报了去棉花堡的行程，天气很冷，沿途都是雪山。",
//   			"userImg": "8.jpg"
//   		}
//   	];
//   var data = {
//   	"title":"在伊斯坦布尔遇见你", 
//   	"nickName": "Sunny", 
//   	"coverImg": "2.jpg",
//   	"contents": contentArr
//   }
//   testInit(data);
  //上面是调用的例子
  })();
/*  http://120.26.129.111/api/getArticle?articleId=5548af8eea0e3ef04fe8a382
 http://120.26.129.111/api/img?Key=5548af8eea0e3ef04fe8a382_1lgeHR
 */