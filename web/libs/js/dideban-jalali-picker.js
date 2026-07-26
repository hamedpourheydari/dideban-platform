(function(window,$){
'use strict';
if(!$||!window.moment)return;
var DD=window.DidebanDate||{};
var months=['فروردین','اردیبهشت','خرداد','تیر','مرداد','شهریور','مهر','آبان','آذر','دی','بهمن','اسفند'];
var week=['ش','ی','د','س','چ','پ','ج'];
function fa(v){return DD.toPersianDigits?DD.toPersianDigits(v):String(v)}
function pad(v){return String(v).padStart(2,'0')}
function div(a,b){return ~~(a/b)}
function mod(a,b){return a-~~(a/b)*b}
function jalCal(jy){var breaks=[-61,9,38,199,426,686,756,818,1111,1181,1210,1635,2060,2097,2192,2262,2324,2394,2456,3178],bl=breaks.length,gy=jy+621,leapJ=-14,jp=breaks[0],jm,jump,leap,leapG,march,n,i;if(jy<jp||jy>=breaks[bl-1])throw new Error('Invalid Jalali year '+jy);for(i=1;i<bl;i++){jm=breaks[i];jump=jm-jp;if(jy<jm)break;leapJ+=div(jump,33)*8+div(mod(jump,33),4);jp=jm}n=jy-jp;leapJ+=div(n,33)*8+div(mod(n,33)+3,4);if(mod(jump,33)===4&&jump-n===4)leapJ++;leapG=div(gy,4)-div((div(gy,100)+1)*3,4)-150;march=20+leapJ-leapG;if(jump-n<6)n=n-jump+div(jump+4,33)*33;leap=mod(mod(n+1,33)-1,4);if(leap===-1)leap=4;return {leap:leap,gy:gy,march:march}}
function g2d(gy,gm,gd){var d=div((gy+div(gm-8,6)+100100)*1461,4)+div(153*mod(gm+9,12)+2,5)+gd-34840408;d=d-div(div(gy+100100+div(gm-8,6),100)*3,4)+752;return d}
function d2g(jdn){var j=4*jdn+139361631;j=j+div(div(4*jdn+183187720,146097)*3,4)*4-3908;var i=div(mod(j,1461),4)*5+308;var gd=div(mod(i,153),5)+1,gm=mod(div(i,153),12)+1,gy=div(j,1461)-100100+div(8-gm,6);return {gy:gy,gm:gm,gd:gd}}
function j2d(jy,jm,jd){var r=jalCal(jy);return g2d(r.gy,3,r.march)+(jm-1)*31-div(jm,7)*(jm-7)+jd-1}
function d2j(jdn){var g=d2g(jdn),jy=g.gy-621,r=jalCal(jy),jdn1f=g2d(g.gy,3,r.march),k=jdn-jdn1f,jm,jd;if(k>=0){if(k<=185){jm=1+div(k,31);jd=mod(k,31)+1;return {jy:jy,jm:jm,jd:jd}}k-=186}else{jy--;k+=179;if(r.leap===1)k++}jm=7+div(k,30);jd=mod(k,30)+1;return {jy:jy,jm:jm,jd:jd}}
function toGregorian(jy,jm,jd){return d2g(j2d(jy,jm,jd))}
function toJalali(gy,gm,gd){return d2j(g2d(gy,gm,gd))}
function isLeap(y){return jalCal(y).leap===0}
function daysInMonth(y,m){if(m<=6)return 31;if(m<=11)return 30;return isLeap(y)?30:29}
function gDate(j,h,min){var g=toGregorian(j.y,j.m,j.d);return moment({year:g.gy,month:g.gm-1,date:g.gd,hour:h,minute:min,second:0,millisecond:0})}
function jParts(m){var d=m.toDate(),p=toJalali(d.getFullYear(),d.getMonth()+1,d.getDate());return {y:p.jy,m:p.jm,d:p.jd}}
function Picker($input,opt,callback){
 this.$input=$input;this.opt=opt||{};this.callback=callback;this.startDate=moment(opt.startDate);this.endDate=moment(opt.endDate);this.active='start';this.view=jParts(this.startDate);this.build();this.syncInput();this.bind();
}
Picker.prototype.build=function(){
 var w=week.map(function(x){return '<span>'+x+'</span>'}).join('');
 this.$el=$('<div class="dideban-jrp" hidden><div class="dideban-jrp-head"><button type="button" class="dideban-jrp-tab active" data-side="start">شروع: <b></b></button><button type="button" class="dideban-jrp-tab" data-side="end">پایان: <b></b></button></div><div class="dideban-jrp-nav"><button type="button" data-nav="prev"><i class="fa fa-chevron-right"></i></button><div class="dideban-jrp-title"></div><button type="button" data-nav="next"><i class="fa fa-chevron-left"></i></button></div><div class="dideban-jrp-week">'+w+'</div><div class="dideban-jrp-grid"></div><div class="dideban-jrp-time"><label>ساعت</label><select data-time="hour"></select><span>:</span><select data-time="minute"></select></div><div class="dideban-jrp-actions"><button type="button" class="dideban-jrp-apply">اعمال بازه</button><button type="button" class="dideban-jrp-cancel">انصراف</button></div></div>');
 for(var h=0;h<24;h++)this.$el.find('[data-time=hour]').append('<option value="'+h+'">'+fa(pad(h))+'</option>');
 for(var m=0;m<60;m+=this.opt.timePickerIncrement||30)this.$el.find('[data-time=minute]').append('<option value="'+m+'">'+fa(pad(m))+'</option>');
 $('body').append(this.$el);
};
Picker.prototype.bind=function(){var self=this;
 this.$input.addClass('dideban-jrp-input').attr('readonly',true).on('click focus',function(e){e.preventDefault();self.open()});
 this.$el.on('click','[data-side]',function(){self.active=$(this).data('side');self.view=jParts(self.active==='start'?self.startDate:self.endDate);self.render()});
 this.$el.on('click','[data-nav]',function(){var d=$(this).data('nav')==='prev'?-1:1;self.view.m+=d;if(self.view.m<1){self.view.m=12;self.view.y--}if(self.view.m>12){self.view.m=1;self.view.y++}self.render()});
 this.$el.on('click','.dideban-jrp-day',function(){var j={y:+$(this).data('y'),m:+$(this).data('m'),d:+$(this).data('d')};var current=self.active==='start'?self.startDate:self.endDate;var next=gDate(j,current.hour(),current.minute());if(self.active==='start'){self.startDate=next;if(self.endDate.isBefore(next))self.endDate=next.clone()}else{self.endDate=next;if(next.isBefore(self.startDate))self.startDate=next.clone()}self.render()});
 this.$el.on('change','[data-time]',function(){var target=self.active==='start'?self.startDate:self.endDate;target.hour(+self.$el.find('[data-time=hour]').val()).minute(+self.$el.find('[data-time=minute]').val());self.renderTabs()});
 this.$el.on('click','.dideban-jrp-apply',function(e){e.preventDefault();e.stopPropagation();if(!self.endDate.isAfter(self.startDate))self.endDate=self.startDate.clone().add(1,'minute');self.syncInput();self.close();var start=self.startDate.clone(),end=self.endDate.clone();setTimeout(function(){self.$input.trigger('dideban:rangeApplied',[start,end]);},0)});
 this.$el.on('click','.dideban-jrp-cancel',function(){self.close()});
 $(document).on('mousedown.didebanJrp',function(e){if(!self.$el.is(e.target)&&self.$el.has(e.target).length===0&&!self.$input.is(e.target))self.close()});
};
Picker.prototype.open=function(){var o=this.$input.offset(),h=this.$input.outerHeight();this.$el.css({top:o.top+h+6,left:Math.max(8,o.left+this.$input.outerWidth()-330)}).removeAttr('hidden');this.render()};
Picker.prototype.close=function(){this.$el.attr('hidden',true)};
Picker.prototype.renderTabs=function(){var a=jParts(this.startDate),b=jParts(this.endDate);this.$el.find('[data-side=start] b').text(fa(a.y+'/'+pad(a.m)+'/'+pad(a.d)+' '+pad(this.startDate.hour())+':'+pad(this.startDate.minute())));this.$el.find('[data-side=end] b').text(fa(b.y+'/'+pad(b.m)+'/'+pad(b.d)+' '+pad(this.endDate.hour())+':'+pad(this.endDate.minute())));this.$el.find('[data-side]').removeClass('active').filter('[data-side='+this.active+']').addClass('active')};
Picker.prototype.render=function(){
 this.renderTabs();this.$el.find('.dideban-jrp-title').text(months[this.view.m-1]+' '+fa(this.view.y));
 var first=DD.jalaliToGregorian(this.view.y,this.view.m,1),dow=(new Date(first.gy,first.gm-1,first.gd).getDay()+1)%7;var html='';
 var pm=this.view.m-1,py=this.view.y;if(pm<1){pm=12;py--}var prevDays=daysInMonth(py,pm);
 for(var i=dow-1;i>=0;i--)html+=this.dayHtml(py,pm,prevDays-i,true);
 var dim=daysInMonth(this.view.y,this.view.m);for(var d=1;d<=dim;d++)html+=this.dayHtml(this.view.y,this.view.m,d,false);
 var cells=dow+dim,next=1,nm=this.view.m+1,ny=this.view.y;if(nm>12){nm=1;ny++}while(cells%7){html+=this.dayHtml(ny,nm,next++,true);cells++}
 this.$el.find('.dideban-jrp-grid').html(html);var t=this.active==='start'?this.startDate:this.endDate;this.$el.find('[data-time=hour]').val(t.hour());var inc=this.opt.timePickerIncrement||30;this.$el.find('[data-time=minute]').val(Math.floor(t.minute()/inc)*inc);
};
Picker.prototype.dayHtml=function(y,m,d,muted){var target=this.active==='start'?jParts(this.startDate):jParts(this.endDate);var cls='dideban-jrp-day'+(muted?' muted':'')+(target.y===y&&target.m===m&&target.d===d?' selected':'');return '<button type="button" class="'+cls+'" data-y="'+y+'" data-m="'+m+'" data-d="'+d+'">'+fa(d)+'</button>'};
Picker.prototype.syncInput=function(){var a=jParts(this.startDate),b=jParts(this.endDate);this.$input.val(fa(a.y+'/'+pad(a.m)+'/'+pad(a.d)+' '+pad(this.startDate.hour())+':'+pad(this.startDate.minute())+' تا '+b.y+'/'+pad(b.m)+'/'+pad(b.d)+' '+pad(this.endDate.hour())+':'+pad(this.endDate.minute())))};
Picker.prototype.setStartDate=function(v){this.startDate=moment(v);this.syncInput()};Picker.prototype.setEndDate=function(v){this.endDate=moment(v);this.syncInput()};
$.fn.didebanJalaliRangePicker=function(opt,callback){return this.each(function(){var $t=$(this),p=new Picker($t,opt,callback);$t.data('daterangepicker',p).data('didebanJalaliRangePicker',p)})};
})(window,window.jQuery);
