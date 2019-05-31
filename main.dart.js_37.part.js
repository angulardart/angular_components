self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={
a4q:function(d,e){var y,x=$.V
if(x===C.ab)return x.u3(d,e)
y=x.tR(e,P.cV)
return $.V.u3(d,y)}},W={
aku:function(d,e){var y=new IntersectionObserver(H.dD(d,2),P.Zf(e,null))
return y}},G={
a1S:function(){if($.abF)return
$.abF=!0
$.ct.C(0,C.bH,new G.a_b())
$.bo.C(0,C.bH,C.av)
E.A()
G.agc()
R.y3()},
a_b:function a_b(){},
pR:function pR(){},
Iy:function Iy(d){this.a=d},
Iz:function Iz(d){this.a=d},
IA:function IA(d){this.a=d},
Ix:function Ix(d,e){this.a=d
this.b=e},
NC:function NC(){},
arH:function(){if($.abD)return
$.abD=!0
G.qS()
V.eS()},
agc:function(){if($.abC)return
$.abC=!0
G.qS()},
qS:function(){if($.abw)return
$.abw=!0
G.a1S()
R.y3()
E.arF()}},Y,R={
alR:function(d,e,f,g,h){var y,x
if(d){y=h==null||h.top>e+J.ip(g)
x=J.af(g)
return x.gcj(g)<e&&y&&f-e-x.gcb(g)>100}else{y=h==null||h.bottom<f-J.ip(g)
x=J.af(g)
return x.gfh(g)>f&&y&&f-e-x.gcb(g)>100}},
alQ:function(d,e,f,g){var y,x,w,v,u,t,s,r=d.b,q=r+d.d,p=new R.tJ([g])
p.a=d
p.e=H.a([],[P.aj])
for(y=[g],x=[g],w=[[R.o1,g]],v=0;v<e.length;++v){u=e[v]
t=u.b===C.bF
s=R.alR(t,r,q,u.f,u.r)
if(s)u.e
if(s&&!0)if(t){t=p.b
if(t==null)t=p.b=H.a([],w)
t.push(new R.o1(u,0,x))
p.e.push(r-J.k0(u.f))
r+=J.ip(u.f)
u.e}else{t=p.c
if(t==null)t=p.c=H.a([],w)
t.push(new R.o1(u,0,x))
p.e.push(q-J.ajo(u.f))
q-=J.ip(u.f)
u.e}else{t=p.d
if(t==null)t=p.d=H.a([],y)
s
t.push(u)}}return p},
J2:function J2(d,e,f,g){var _=this
_.a=d
_.b=e
_.e=_.c=null
_.f=f
_.r=g
_.y=_.x=null
_.z=!1},
J4:function J4(){},
J5:function J5(d){this.a=d},
J3:function J3(){},
jL:function jL(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.r=_.f=null
_.z=_.y=_.x=""
_.Q=0},
o1:function o1(d,e,f){this.a=d
this.b=e
this.$ti=f},
tJ:function tJ(d){var _=this
_.e=_.d=_.c=_.b=_.a=null
_.$ti=d},
ZL:function(){if($.abv)return
$.abv=!0
$.ct.C(0,C.h1,new R.a_a())
$.bo.C(0,C.h1,C.lB)
E.A()
G.a1S()
N.arE()
R.y3()
R.y3()
G.qS()
R.ly()},
a_a:function a_a(){},
arG:function(){if($.abE)return
$.abE=!0
E.A()
G.qS()
X.hk()
V.d3()},
y3:function(){if($.aby)return
$.aby=!0}},K={H4:function H4(){var _=this
_.fx=_.fr=_.dy=_.dx=_.r=_.f=null}},V={la:function la(){},Iw:function Iw(){},tK:function tK(d){this.b=d}},S,E={
arF:function(){if($.abx)return
$.abx=!0
G.qS()}},M={a17:function a17(){}},Q,D,L,Z={pS:function pS(d){this.b=d}},O,B={
aho:function(d,e){var y=Math.abs(d),x=Math.abs(e)
if(e>=y)return C.bb
else if(e<=-y)return C.bc
else if(d>x)return C.bA
else if(d<-x)return C.bz
return},
ah_:function(d,e){var y,x,w,v,u=P.aZ([C.bb,!1,C.bc,!1,C.bz,!1,C.bA,!1],B.fv,P.u),t=e
while(!0){if(!((t==null?d!=null:t!==d)&&t!=null))break
y=window.getComputedStyle(t,"")
x=y.getPropertyValue((y&&C.E).bQ(y,"overflow-x"))
w=x==null?"":x
if(w==="auto"||w==="scroll"){u.C(0,C.bz,u.D(0,C.bz)||C.y.aT(t.scrollLeft)>0)
u.C(0,C.bA,u.D(0,C.bA)||C.y.aT(t.scrollLeft)+t.clientWidth<C.y.aT(t.scrollWidth))}x=y.getPropertyValue(C.E.bQ(y,"overflow-y"))
v=x==null?"":x
if(v==="auto"||v==="scroll"){u.C(0,C.bb,u.D(0,C.bb)||C.y.aT(t.scrollTop)>0)
u.C(0,C.bc,u.D(0,C.bc)||C.y.aT(t.scrollTop)+t.clientHeight<C.y.aT(t.scrollHeight))}t=t.parentElement}return u},
fv:function fv(d){this.b=d},
hC:function hC(d){this.a=d},
pc:function pc(d){this.b=d},
rR:function rR(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.y=_.x=_.r=_.f=_.e=null
_.z=!1},
vs:function vs(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.y=_.x=_.r=_.f=_.e=_.d=null
_.z=!1
_.Q=null}},A,U,T={mi:function mi(d,e,f,g,h){var _=this
_.dy=d
_.a=e
_.b=f
_.e=_.d=_.c=null
_.f=g
_.Q=_.z=_.y=_.x=_.r=null
_.cx=h
_.db=_.cy=!1
_.dx=0}},N={
arE:function(){if($.abz)return
$.abz=!0
E.A()
G.a1S()
R.arG()
G.arH()
G.agc()
R.y3()
F.arI()
X.hk()
V.d3()}},X,F={
arI:function(){if($.abB)return
$.abB=!0
G.qS()
V.d3()}}
a.setFunctionNamesIfNecessary([P,W,G,R,K,V,E,M,Z,B,T,N,F])
C=c[0]
H=c[1]
J=c[2]
P=a.updateHolder(c[3],P)
W=a.updateHolder(c[4],W)
G=a.updateHolder(c[5],G)
Y=c[6]
R=a.updateHolder(c[7],R)
K=a.updateHolder(c[8],K)
V=a.updateHolder(c[9],V)
S=c[10]
E=a.updateHolder(c[11],E)
M=a.updateHolder(c[12],M)
Q=c[13]
D=c[14]
L=c[15]
Z=a.updateHolder(c[16],Z)
O=c[17]
B=a.updateHolder(c[18],B)
A=c[19]
U=c[20]
T=a.updateHolder(c[21],T)
N=a.updateHolder(c[22],N)
X=c[23]
F=a.updateHolder(c[24],F)
B.fv.prototype={
L:function(d){return this.b}}
B.hC.prototype={}
B.pc.prototype={}
B.rR.prototype={
YN:function(){var y,x,w,v,u=this
if(u.f!=null)return
y=new R.J(!0)
u.f=y
x=u.a
w=J.af(x)
v=w.gGf(x)
y.b0(W.bZ(v.a,v.b,u.gXi(),!1,H.e(v,0)))
v=u.f
y=w.gGe(x)
v.b0(W.bZ(y.a,y.b,u.gXg(),!1,H.e(y,0)))
y=u.f
x=w.gGd(x)
y.b0(W.bZ(x.a,x.b,u.gXe(),!1,H.e(x,0)))},
KC:function(){if(this.e.d!=null)return
this.f.F()
this.f=null},
Cw:function(d){var y,x,w,v=this
if(d.touches.length>1)return
v.x=B.ah_(v.a,W.cH(d.target))
y=d.touches
y=(y&&C.bq).gdz(y)
x=[P.aj]
v.y=new P.fa(C.y.aT(y.screenX),C.y.aT(y.screenY),x)
v.z=!1
y=v.r
if(y!=null){y.z=!0
y.d.ay(0)}y=v.c
w=v.r=new B.vs(v.e,y,C.eK)
w.d=P.a4q(C.eK,w.gJd())
w.f=w.e=y.a.$0()
y=d.touches
y=(y&&C.bq).gdz(y)
w.y=w.x=w.r=new P.fa(C.y.aT(y.screenX),C.y.aT(y.screenY),x)
w.Q=W.cH(d.target)},
Xh:function(d){var y,x,w=this,v=w.r
if(v==null)return
if(v.z)return w.Cw(d)
if(!w.z){v=d.touches
v=(v&&C.bq).gaw(v)
y=new P.fa(C.y.aT(v.screenX),C.y.aT(v.screenY),[P.aj]).i8(0,w.y)
v=y.b
if(!(v>0&&w.x.D(0,C.bb)))if(!(v<0&&w.x.D(0,C.bc))){x=y.a
if(!(x>0&&w.x.D(0,C.bz)))x=x<0&&w.x.D(0,C.bA)
else x=!0}else x=!0
else x=!0
if(x)return w.r=null
if(!w.b.$1(B.aho(y.a,v)))return w.r=null
w.z=!0}d.stopPropagation()
d.preventDefault()
v=w.r
v.f=v.b.a.$0()
x=d.touches
x=(x&&C.bq).gaw(x)
v.x=new P.fa(C.y.aT(x.screenX),C.y.aT(x.screenY),[P.aj])},
Xf:function(d){if(this.r==null)return
d.stopPropagation()
this.r.a_C(0)},
F:function(){var y=this,x=y.r
if(x!=null){x.z=!0
x.d.ay(0)}y.r=null
x=y.e
if(x!=null)x.bY(0)
y.e=null
x=y.f
if(x!=null)x.F()
y.f=null},
$icl:1}
B.vs.prototype={
gDR:function(){var y=this,x=y.r.a,w=y.x.a,v=y.f,u=y.e,t=C.k.e2(P.iB(0,v.a-u.a,0,0).a,1000)
return t===0?0:(x-w)/t},
gDS:function(){var y=this,x=y.r.b,w=y.x.b,v=y.f,u=y.e,t=C.k.e2(P.iB(0,v.a-u.a,0,0).a,1000)
return t===0?0:(x-w)/t},
gDQ:function(){var y=this.gDR(),x=this.gDS()
return Math.sqrt(y*y+x*x)},
a_C:function(d){var y=this
if(y.z)return
y.z=!0
y.d.ay(0)
if(Math.abs(y.gDQ())>=2)y.d=P.a4q(y.c,y.gJg())
else y.Dw()},
Dw:function(){var y=this,x=y.y.i8(0,y.x)
if(x.a!==0||x.b!==0){y.a.P(0,new B.pc(x.b))
y.y=y.x}},
Je:function(d){var y=this
if(y.f.P(0,C.cp).a<y.b.a.$0().a){y.z=!0
y.d.ay(0)
return}y.Dw()},
Jh:function(d){var y,x,w=this,v=w.b.a.$0(),u=w.f,t=C.k.e2(P.iB(0,v.a-u.a,0,0).a,1000),s=Math.abs(w.gDQ())-0.005*t
u=J.a37(w.gDR())
v=C.k.e2(w.c.a,1000)
y=C.y.aT(s*u*v)
x=C.y.aT(s*J.a37(w.gDS())*v)
if(s>0)v=y!==0||x!==0
else v=!1
if(v)w.a.P(0,new B.pc(x))
else{w.z=!0
w.d.ay(0)}}}
K.H4.prototype={
F:function(){},
$icl:1}
M.a17.prototype={}
G.pR.prototype={
p8:function(d,e,f,g){var y,x,w,v=this
v.gkP()
v.c=new K.H4()
y=W.at
x=P.eH(null,null,y)
v.d=new R.J2(v.a,v,P.ak(y,R.jL),x)
if($.aj3())v.e=new B.rR(v.gkP(),v.gyi(),f.a)
if($.aj5()){w=!!J.M(v.glK()).$iat?v.glK():null
v.r=W.aku(P.hh(v.gWI()),P.a0t(["root",w]))}},
gk5:function(){return this.d},
goS:function(){var y=this
return Math.max(0,1+y.gvs(y)-y.gtY(y))},
ZA:function(){var y=this
return P.fb(y.gG8(),y.gG9(),y.gEh(y),y.gtY(y),P.aj)},
F:function(){var y,x=this
x.c.F()
x.d.F()
x.Q=null
y=x.r
if(y!=null){y.disconnect()
for(y=x.f,y=y.gdi(y),y=y.gbf(y);y.ad();)y.gaA(y).bY(0)}y=x.z
if(y!=null){y.ay(0)
x.z=null}},
Hz:function(){var y,x=this
if(x.z==null){y=x.x
if(y==null)y=x.x=new P.a7(x.gYI(),x.gYQ(),[V.la])
x.z=new P.o(y,[H.e(y,0)]).B(x.gX2())}},
mp:function(d){switch(d){case C.bb:return!0
case C.bc:return!0
default:return!1}},
YJ:function(){var y,x,w,v,u=this
if(u.y!=null)return
y=new R.J(!0)
u.y=y
x=u.e
if(x!=null){w=x.e
if(w==null){w=x.gYM()
v=x.gKB()
x=x.e=new P.a7(w,v,[B.pc])}else x=w
y.b0(new P.o(x,[H.e(x,0)]).B(new G.Iy(u)))}y=u.y
x=J.ajw(u.gkP())
y.b0(W.bZ(x.a,x.b,new G.Iz(u),!1,H.e(x,0)))
y=u.y
x=J.a35(u.glK())
y.b0(W.bZ(x.a,x.b,new G.IA(u),!1,H.e(x,0)))},
YR:function(){if(this.x.d!=null)return
this.y.F()
this.y=null},
X3:function(d){var y=this,x=y.dx,w=d.b
y.dx=x+(w==null?0:w)
if(y.db&&!0)return
y.db=!0
C.as.hc(window,new G.Ix(y,d))},
WJ:function(d,e){var y,x,w,v
for(y=J.bM(d),x=this.f;y.ad();){w=y.gaA(y)
v=x.D(0,w.target)
if(v!=null){if(!v.gfP())H.L(v.fH())
v.eA(w)}}},
$icl:1}
G.NC.prototype={
glK:function(){return this.dy},
gvt:function(){var y=this.dy
y.toString
return"scrollY" in y?C.y.aT(y.scrollY):C.y.aT(y.document.documentElement.scrollTop)},
lJ:function(d){var y=this.dy
C.as.H5(y,(y&&C.as).gvu(y),d)
this.d.lS()},
gvs:function(d){var y=this.dy,x=!!J.M(y.document).$ihD?C.y.aT(H.eh(y.document,"$ihD").body.scrollHeight):0
return Math.max(x,C.y.aT(y.document.documentElement.scrollHeight))},
gtY:function(d){return this.dy.document.documentElement.clientHeight},
gEh:function(d){return this.dy.document.documentElement.clientWidth},
gkP:function(){return this.dy.document.documentElement},
vQ:function(d){d.stopPropagation()},
gG8:function(){return 0},
gG9:function(){return 0}}
Z.pS.prototype={$ila:1}
V.la.prototype={}
V.Iw.prototype={$icl:1}
V.tK.prototype={
L:function(d){return this.b}}
R.J2.prototype={
HC:function(d,e,f,g,h){var y,x=this.f,w=x.D(0,d)
if(w!=null)if(w.b===e){y=w.c
y=(y==null?f==null:y===f)&&!0}else y=!1
else y=!1
if(y)return
this.vi(d)
x.C(0,d,new R.jL(d,e,f,g,h))
this.YK()},
vi:function(d){var y,x,w,v,u=this
u.x=null
y=u.f
x=y.bn(0,d)
if(x==null)return
w=u.y
if(w!=null){v=w.b
if(v!=null)C.e.bn(v,x)
v=w.c
if(v!=null)C.e.bn(v,x)
w=w.d
if(w!=null)C.e.bn(w,x)}x.vK()
if(x.x!==""){w=x.a.style
x.x=w.position=""}if(y.gb8(y)){y=u.e
if(y!=null){y.ay(0)
u.e=null}}},
lS:function(){var y=this.f
if(y.gbO(y))this.ww()},
ga2i:function(){var y=this.c
if(y==null)y=this.c=new P.y(null,null,[P.K])
return new P.o(y,[H.e(y,0)])},
F:function(){var y,x,w=this.f
if(w.gbO(w)){y=P.c1(w.gbU(w),!0,W.at)
for(w=y.length,x=0;x<y.length;y.length===w||(0,H.aE)(y),++x)this.vi(y[x])}w=this.c
if(w!=null)w.bY(0)},
Y6:function(){this.a.cL(new R.J4())},
YK:function(){var y=this
if(y.e!=null)return
y.e=y.a.got().B(new R.J5(y))
y.b.Hz()
y.Y6()},
KE:function(){var y,x,w,v,u,t,s,r,q,p=this.b.ZA()
for(y=this.r,y=P.mn(y,y.r,H.e(y,0)),x=P.aj;y.ad();){w=y.d.getBoundingClientRect()
v=w.top+w.height/2
u=p.b
t=u+p.d
if(Math.abs(u-v)<Math.abs(t-v)){s=Math.max(u,w.bottom)
r=t-s
if(s!==u&&r>0)p=P.fb(p.a,s,p.c,r,x)}else{q=Math.min(t,w.top)
r=q-u
if(q!==t&&r>0)p=P.fb(p.a,u,p.c,r,x)}}return P.fb(p.a,p.b,p.c,p.d,x)},
ww:function(){var y,x,w,v=this
v.Ww()
y=R.alQ(v.KE(),v.x,!1,R.jL)
if(!y.ar(0,v.y)&&v.x!=null){v.YZ(y)
x=v.c
w=x==null?null:x.d!=null
if(w===!0)x.P(0,null)}},
Ww:function(){var y,x,w,v,u=this
if(u.x==null){y=u.f
y=y.gdi(y)
u.x=P.c1(y,!0,H.aN(y,"R",0))}for(y=P.aj,x=0;w=u.x,x<w.length;++x){w=w[x]
v=w.f=w.a.getBoundingClientRect()
w.f=P.fb((v&&C.py).gcc(v),J.k0(w.f)-w.Q,J.oO(w.f),J.ip(w.f),y)
v=w.c
w.r=v==null?null:v.getBoundingClientRect()}(w&&C.e).vL(w,new R.J3())},
YZ:function(d){var y,x,w,v
if(d.b!=null){y=d.a.b
for(x=0;w=d.b,x<w.length;++x){v=w[x]
w=v.a
w.G0(y+v.b)
y+=J.ip(w.f)}}if(d.c!=null){w=d.a
y=w.b+w.d
for(x=0;w=d.c,x<w.length;++x){v=w[x]
w=v.a
y-=J.ip(w.f)
w.G0(y+v.b)}}if(d.d!=null)for(x=0;w=d.d,x<w.length;++x)w[x].vK()
this.y=d},
$icl:1,
sa_n:function(d){return this.z=d}}
R.jL.prototype={
vK:function(){var y,x=this
if(x.Q===0)return
x.Q=0
if(x.y!==""||x.z!==""){y=x.a.style
C.E.c0(y,(y&&C.E).bQ(y,"transform"),"","")
y.zIndex=""}x.z=x.y=""},
G0:function(d){var y,x,w=this,v="relative",u=d-J.k0(w.f)
if(w.Q!==u){y=C.y.aT(u)
w.Q=y
x="translate3d(0px, "+y+"px, 0px)"
if(w.x!=="relative"||w.y!==x||w.z!=="100"){y=w.a.style
y.position=v
C.E.c0(y,(y&&C.E).bQ(y,"transform"),x,"")
y.zIndex="100"
w.x=v
w.y=x
w.z="100"}}},
L:function(d){var y=this,x=y.b
return"_StickyRow "+P.f_(P.aZ(["isBottom",x===C.mr,"isTop",x===C.bF,"rowPosition",y.f,"rangePosition",y.r,"translateY",y.Q,"stickyClass",y.d],P.j,P.k))}}
R.o1.prototype={
ar:function(d,e){var y,x=this
if(e==null)return!1
if(x!==e)y=e instanceof R.o1&&new H.bD(H.oz(x)).ar(0,new H.bD(H.oz(e)))&&J.a1(x.a,e.a)&&x.b===e.b
else y=!0
return y},
gaH:function(d){return(J.bI(this.a)^C.y.gaH(this.b))>>>0},
L:function(d){return"_RowData{row: "+H.w(this.a)+", offsetY: "+H.w(this.b)+"}"}}
R.tJ.prototype={
ar:function(d,e){var y=this
if(e==null)return!1
return e instanceof R.tJ&&J.a1(y.a,e.a)&&y.ms(y.b,e.b)&&y.ms(y.c,e.c)&&y.ms(y.d,e.d)&&y.ms(y.e,e.e)},
ms:function(d,e){var y,x,w=d==null
if(w&&e==null)return!0
if(w||e==null)return!1
if(d.length!==e.length)return!1
for(y=0;y<d.length;++y)if(!J.a1(d[y],e[y])){w=d[y]
if(typeof w==="number"){x=e[y]
x=typeof x==="number"}else x=!1
if(x){if(J.a04(w)!==J.a04(e[y]))return!1}else return!1}return!0},
L:function(d){var y=this
return"StickyContainerLayout "+P.f_(P.aZ(["hostPosition",y.a,"topRows",y.b,"bottomRows",y.c,"hiddenRows",y.d,"_translateYs",y.e],P.j,P.k))}}
T.mi.prototype={}
var z=a.updateTypes([{func:1,ret:-1},{func:1,ret:-1,args:[W.cW]},{func:1,ret:-1,args:[P.cV]},{func:1,ret:B.hC,args:[V.e6]},{func:1,ret:P.u,args:[B.fv]},{func:1,ret:-1,args:[V.la]},{func:1,ret:-1,args:[[P.R,,],W.ng]},{func:1,ret:P.K,args:[V.la]},{func:1,ret:P.C,args:[R.jL,R.jL]},{func:1,ret:T.mi,args:[F.da,Y.dv,B.hC,W.ey]}])
G.a_b.prototype={
$1:function(d){return new B.hC(d)},
$S:z+3}
G.Iy.prototype={
$1:function(d){this.a.x.P(0,d)},
$S:z+7}
G.Iz.prototype={
$1:function(d){var y,x,w,v,u,t,s,r,q,p=null
if(!J.M(d).$ii5)return
u=d.ctrlKey
if(u!==!0){u=d.metaKey
if(u!==!0){u=d.shiftKey
u=u===!0}else u=!0}else u=!0
if(u)return
y=null
x=null
try{y=C.cT.ga_9(d)
if(y==null)$.yo().jC(C.bQ,"deltaX is null in event: "+H.w(d),p,p)}catch(t){u=H.aA(t)
if(!!J.M(u).$inJ){w=u
$.yo().jC(C.bQ,"deltaX is not supported in event: "+H.w(d),w,p)}else throw t}if(y==null)y=0
try{x=C.cT.ga_a(d)
if(x==null)$.yo().jC(C.bQ,"deltaY is null in event: "+H.w(d),p,p)}catch(t){u=H.aA(t)
if(!!J.M(u).$inJ){v=u
$.yo().jC(C.bQ,"deltaY is not supported in event: "+H.w(d),v,p)}else throw t}if(x==null)x=0
s=B.aho(y,J.ajb(x))
if(J.a1(x,0)||!this.a.mp(s))return
u=this.a
if(B.ah_(u.gkP(),W.cH(d.target)).D(0,s))return
u.vQ(d)
r=C.cT.ga_8(d)===0?1:16
q=J.yz(x)
u.x.P(0,new Z.pS(q*r))},
$S:212}
G.IA.prototype={
$1:function(d){var y=this.a
if(y.cy){y.cy=!1
return}y.x.P(0,new Z.pS(0))},
$S:8}
G.Ix.prototype={
$1:function(d){var y=this.a,x=y.dx
if(x!==0){y.cy=!0
y.lJ(y.gvt()+x)}y.d.lS()
y.db=!1
y.dx=0},
$S:9}
R.J4.prototype={
$0:function(){},
$S:0}
R.J5.prototype={
$1:function(d){this.a.ww()},
$S:4}
R.J3.prototype={
$2:function(d,e){var y=d.b===C.bF
if(y!==(e.b===C.bF))return y?-1:1
return y?C.y.bZ(J.k0(d.f),J.k0(e.f)):C.y.bZ(J.k0(e.f),J.k0(d.f))},
$S:z+8}
R.a_a.prototype={
$4:function(d,e,f,g){var y=new T.mi(g,d,e,P.ak(W.at,[P.pV,W.lU]),!1)
y.p8(d,e,f,!1)
return y},
$C:"$4",
$R:4,
$S:z+9};(function installTearOffs(){var y=a._instance_0u,x=a._instance_1u,w=a._instance_2u
var v
y(v=B.rR.prototype,"gYM","YN",0)
y(v,"gKB","KC",0)
x(v,"gXi","Cw",1)
x(v,"gXg","Xh",1)
x(v,"gXe","Xf",1)
x(v=B.vs.prototype,"gJd","Je",2)
x(v,"gJg","Jh",2)
x(v=G.pR.prototype,"gyi","mp",4)
y(v,"gYI","YJ",0)
y(v,"gYQ","YR",0)
x(v,"gX2","X3",5)
w(v,"gWI","WJ",6)})();(function inheritance(){var y=a.inheritMany,x=a.inherit
y(P.k,[B.fv,B.hC,Z.pS,B.rR,B.vs,K.H4,M.a17,G.pR,V.la,V.Iw,V.tK,R.J2,R.jL,R.o1,R.tJ])
x(B.pc,Z.pS)
y(H.aW,[G.a_b,G.Iy,G.Iz,G.IA,G.Ix,R.J4,R.J5,R.J3,R.a_a])
x(G.NC,G.pR)
x(T.mi,G.NC)})();(function constants(){var y=a.makeConstList
C.eK=new P.bW(17e3)
C.bb=new B.fv("GestureDirection.up")
C.bc=new B.fv("GestureDirection.down")
C.bz=new B.fv("GestureDirection.left")
C.bA=new B.fv("GestureDirection.right")
C.kO=H.a(y([C.aa]),[P.k])
C.av=H.a(y([C.kO]),[[P.q,P.k]])
C.bH=H.x(B.hC)
C.kQ=H.a(y([C.bH]),[P.k])
C.lB=H.a(y([C.bT,C.bU,C.kQ,C.cu]),[[P.q,P.k]])
C.bF=new V.tK("StickyPosition.TOP")
C.mr=new V.tK("StickyPosition.BOTTOM")
C.c8=H.x(V.Iw)
C.h1=H.x(T.mi)})();(function staticFields(){$.abF=!1
$.abE=!1
$.abD=!1
$.abz=!1
$.abC=!1
$.aby=!1
$.abx=!1
$.abB=!1
$.abv=!1
$.abw=!1})();(function lazyInitializers(){var y=a.lazy
y($,"aL0","yo",function(){return N.t4("ScrollHostBase")})
y($,"aM6","aj3",function(){var x=W.a2u().matchMedia("(pointer: coarse)").matches
return x===!0||$.yq().oh("__acxForceTouchEnabled")})
y($,"aMf","aj5",function(){return $.yq().oh("IntersectionObserver")})})()}
$__dart_deferred_initializers__["OtlXtCZtJMb05atcIHj+bhdNmmk="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_37.part.js.map
