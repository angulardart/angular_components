self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={
a5i:function(d,e){var y,x
y=$.S
if(y===C.a1)return y.uo(d,e)
x=y.ub(e,P.dd)
return $.S.uo(d,x)}},W={
anM:function(d,e){var y=new IntersectionObserver(H.eh(d,2),P.Zr(e,null))
return y}},G={
a2u:function(){if($.abp)return
$.abp=!0
$.cp().w(0,C.bI,new G.a_n())
$.d9().w(0,C.bI,C.au)
E.z()
G.afZ()
R.yI()},
a_n:function a_n(){},
qg:function qg(){},
Jn:function Jn(d){this.a=d},
Jo:function Jo(d){this.a=d},
Jp:function Jp(d){this.a=d},
Jm:function Jm(d,e){this.a=d
this.b=e},
Ok:function Ok(){},
auW:function(){if($.abn)return
$.abn=!0
G.rl()
V.fJ()},
afZ:function(){if($.abm)return
$.abm=!0
G.rl()},
rl:function(){if($.abg)return
$.abg=!0
G.a2u()
R.yI()
E.auU()}},Y,R={
apf:function(d,e,f,g,h){var y,x
if(d){y=h==null||h.top>e+J.jb(g)
x=J.V(g)
return x.gcn(g)<e&&y&&f-e-x.gcd(g)>100}else{y=h==null||h.bottom<f-J.jb(g)
x=J.V(g)
return x.gfi(g)>f&&y&&f-e-x.gcd(g)>100}},
ape:function(d,e,f,g){var y,x,w,v,u,t,s,r,q,p
y=d.b
x=y+d.d
w=new R.uj([g])
w.a=d
w.e=H.b([],[P.ad])
for(v=[g],u=[g],t=[[R.oj,g]],s=0;s<e.length;++s){r=e[s]
q=R.apf(r.gGz(),y,x,r.glU(),r.ga31())
if(q)r.gps()
if(q&&!0)if(r.gGz()){p=w.b
if(p==null){p=H.b([],t)
w.b=p}p.push(new R.oj(r,0,u))
w.e.push(y-J.lK(r.glU()))
y+=J.jb(r.glU())
r.gps()}else{p=w.c
if(p==null){p=H.b([],t)
w.c=p}p.push(new R.oj(r,0,u))
w.e.push(x-J.amE(r.glU()))
x-=J.jb(r.glU())
r.gps()}else{p=w.d
if(p==null){p=H.b([],v)
w.d=p}q
p.push(r)}}return w},
JS:function JS(d,e,f,g){var _=this
_.a=d
_.b=e
_.e=_.c=null
_.f=f
_.r=g
_.y=_.x=null
_.z=!1},
JU:function JU(){},
JV:function JV(d){this.a=d},
JT:function JT(){},
kF:function kF(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.r=_.f=null
_.z=_.y=_.x=""
_.Q=0},
oj:function oj(d,e,f){this.a=d
this.b=e
this.$ti=f},
uj:function uj(d){var _=this
_.e=_.d=_.c=_.b=_.a=null
_.$ti=d},
ZV:function(){if($.abf)return
$.abf=!0
$.cp().w(0,C.h1,new R.a_m())
$.d9().w(0,C.h1,C.lO)
E.z()
G.a2u()
N.auT()
R.yI()
R.yI()
G.rl()
R.lC()},
a_m:function a_m(){},
auV:function(){if($.abo)return
$.abo=!0
E.z()
G.rl()
X.j5()
V.du()},
yI:function(){if($.abi)return
$.abi=!0}},K={HO:function HO(){var _=this
_.fx=_.fr=_.dy=_.dx=_.r=_.f=_.d=null}},V={li:function li(){},Jl:function Jl(){},uk:function uk(d){this.b=d}},S,N={
auT:function(){if($.abk)return
$.abk=!0
E.z()
G.a2u()
R.auV()
G.auW()
G.afZ()
R.yI()
F.auX()
X.j5()
V.du()}},E={
auU:function(){if($.abh)return
$.abh=!0
G.rl()}},M={a1C:function a1C(){}},Q,D,L,Z={qh:function qh(d){this.b=d}},A,U,T={mw:function mw(d,e,f,g,h){var _=this
_.dy=d
_.fx=_.fr=0
_.a=e
_.b=f
_.e=_.d=_.c=null
_.f=g
_.Q=_.z=_.y=_.x=_.r=null
_.cx=h
_.db=_.cy=!1
_.dx=0}},O,X,B={
ah2:function(d,e){var y,x
y=Math.abs(d)
x=Math.abs(e)
if(e>=y)return C.b3
else if(e<=-y)return C.b4
else if(d>x)return C.bB
else if(d<-x)return C.bA
return},
agG:function(d,e){var y,x,w,v,u,t
y=P.a0([C.b3,!1,C.b4,!1,C.bA,!1,C.bB,!1],B.ib,P.q)
x=e
while(!0){if(!((x==null?d!=null:x!==d)&&x!=null))break
w=window.getComputedStyle(x,"")
v=w.getPropertyValue((w&&C.B).bS(w,"overflow-x"))
u=v==null?"":v
if(u==="auto"||u==="scroll"){y.w(0,C.bA,y.C(0,C.bA)||C.u.aQ(x.scrollLeft)>0)
y.w(0,C.bB,y.C(0,C.bB)||C.u.aQ(x.scrollLeft)+x.clientWidth<C.u.aQ(x.scrollWidth))}v=w.getPropertyValue(C.B.bS(w,"overflow-y"))
t=v==null?"":v
if(t==="auto"||t==="scroll"){y.w(0,C.b3,y.C(0,C.b3)||C.u.aQ(x.scrollTop)>0)
y.w(0,C.b4,y.C(0,C.b4)||C.u.aQ(x.scrollTop)+x.clientHeight<C.u.aQ(x.scrollHeight))}x=x.parentElement}return y},
ib:function ib(d){this.b=d},
ji:function ji(d){this.a=d},
pz:function pz(d){this.b=d},
to:function to(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.y=_.x=_.r=_.f=_.e=null
_.z=!1},
wa:function wa(d,e,f){var _=this
_.a=d
_.b=e
_.c=f
_.y=_.x=_.r=_.f=_.e=_.d=null
_.z=!1
_.Q=null}},F={
auX:function(){if($.abl)return
$.abl=!0
G.rl()
V.du()}}
a.setFunctionNamesIfNecessary([P,W,G,R,K,V,N,E,M,Z,T,B,F])
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
N=a.updateHolder(c[11],N)
E=a.updateHolder(c[12],E)
M=a.updateHolder(c[13],M)
Q=c[14]
D=c[15]
L=c[16]
Z=a.updateHolder(c[17],Z)
A=c[18]
U=c[19]
T=a.updateHolder(c[20],T)
O=c[21]
X=c[22]
B=a.updateHolder(c[23],B)
F=a.updateHolder(c[24],F)
B.ib.prototype={
I:function(d){return this.b}}
B.ji.prototype={}
B.pz.prototype={}
B.to.prototype={
Zg:function(){var y,x,w,v
if(this.f!=null)return
y=new R.E(!0)
this.f=y
x=this.a
w=J.V(x)
v=w.gH3(x)
y.b4(W.bS(v.a,v.b,this.gXO(),!1,H.f(v,0)))
v=this.f
y=w.gH2(x)
v.b4(W.bS(y.a,y.b,this.gXM(),!1,H.f(y,0)))
y=this.f
x=w.gH1(x)
y.b4(W.bS(x.a,x.b,this.gXK(),!1,H.f(x,0)))},
Lq:function(){if(this.e.d!=null)return
this.f.E()
this.f=null},
De:function(d){var y,x,w,v
if(d.touches.length>1)return
this.x=B.agG(this.a,W.cV(d.target))
y=d.touches
y=(y&&C.bn).gdz(y)
x=[P.ad]
this.y=new P.hL(C.u.aQ(y.screenX),C.u.aQ(y.screenY),x)
this.z=!1
y=this.r
if(y!=null){y.z=!0
y.d.au(0)}y=this.c
w=this.d
v=new B.wa(this.e,y,w)
this.r=v
v.d=P.a5i(w,v.gJX())
y=y.a.$0()
v.e=y
v.f=y
y=d.touches
y=(y&&C.bn).gdz(y)
x=new P.hL(C.u.aQ(y.screenX),C.u.aQ(y.screenY),x)
v.r=x
v.x=x
v.y=x
v.Q=W.cV(d.target)},
XN:function(d){var y,x,w
y=this.r
if(y==null)return
if(y.z)return this.De(d)
if(!this.z){y=d.touches
y=(y&&C.bn).gav(y)
x=new P.hL(C.u.aQ(y.screenX),C.u.aQ(y.screenY),[P.ad]).ij(0,this.y)
y=x.b
if(!(y>0&&this.x.C(0,C.b3)))if(!(y<0&&this.x.C(0,C.b4))){w=x.a
if(!(w>0&&this.x.C(0,C.bA)))w=w<0&&this.x.C(0,C.bB)
else w=!0}else w=!0
else w=!0
if(w){this.r=null
return}if(!this.b.$1(B.ah2(x.a,y))){this.r=null
return}this.z=!0}d.stopPropagation()
d.preventDefault()
y=this.r
y.f=y.b.a.$0()
w=d.touches
w=(w&&C.bn).gav(w)
y.x=new P.hL(C.u.aQ(w.screenX),C.u.aQ(w.screenY),[P.ad])},
XL:function(d){if(this.r==null)return
d.stopPropagation()
this.r.a04(0)},
E:function(){var y=this.r
if(y!=null){y.z=!0
y.d.au(0)}this.r=null
y=this.e
if(y!=null)y.bn(0)
this.e=null
y=this.f
if(y!=null)y.E()
this.f=null},
$icx:1}
B.wa.prototype={
gEx:function(){var y,x,w,v,u
y=this.r.a
x=this.x.a
w=this.f
v=this.e
u=C.i.dZ(P.l0(0,w.a-v.a,0,0).a,1000)
return u===0?0:(y-x)/u},
gEy:function(){var y,x,w,v,u
y=this.r.b
x=this.x.b
w=this.f
v=this.e
u=C.i.dZ(P.l0(0,w.a-v.a,0,0).a,1000)
return u===0?0:(y-x)/u},
gEw:function(){var y,x
y=this.gEx()
x=this.gEy()
return Math.sqrt(y*y+x*x)},
a04:function(d){if(this.z)return
this.z=!0
this.d.au(0)
if(Math.abs(this.gEw())>=2)this.d=P.a5i(this.c,this.gK_())
else this.Ec()},
Ec:function(){var y=this.y.ij(0,this.x)
if(y.a!==0||y.b!==0){this.a.N(0,new B.pz(y.b))
this.y=this.x}},
JY:function(d){if(this.f.N(0,C.cj).a<this.b.a.$0().a){this.z=!0
this.d.au(0)
return}this.Ec()},
K0:function(d){var y,x,w,v,u,t
y=this.b.a.$0()
x=this.f
w=C.i.dZ(P.l0(0,y.a-x.a,0,0).a,1000)
v=Math.abs(this.gEw())-0.005*w
x=J.a41(this.gEx())
y=C.i.dZ(this.c.a,1000)
u=C.u.aQ(v*x*y)
t=C.u.aQ(v*J.a41(this.gEy())*y)
if(v>0)y=u!==0||t!==0
else y=!1
if(y)this.a.N(0,new B.pz(t))
else{this.z=!0
this.d.au(0)}}}
K.HO.prototype={
E:function(){},
$icx:1}
M.a1C.prototype={}
G.qg.prototype={
px:function(d,e,f,g){var y,x,w
this.gld()
this.c=new K.HO()
y=W.ar
x=P.fS(null,null,y)
this.d=new R.JS(this.a,this,P.e(y,R.kF),x)
if($.aiE())this.e=new B.to(this.gld(),this.gz1(),f.a,C.j2)
if($.amm()){w=!!J.L(this.gm8()).$iar?this.gm8():null
this.r=W.anM(P.j1(this.gXd()),P.a0A(["root",w]))}},
gkx:function(){return this.d},
gpf:function(){return Math.max(0,1+this.gw8(this)-this.gui(this))},
ZY:function(){return P.iM(this.gGY(),this.gGZ(),this.gEY(this),this.gui(this),P.ad)},
E:function(){this.c.E()
this.d.E()
var y=this.r
if(y!=null){y.disconnect()
for(y=this.f,y=y.gdh(y),y=y.gbr(y);y.ad();)y.gaG(y).bn(0)}y=this.z
if(y!=null){y.au(0)
this.z=null}},
Im:function(){if(this.z==null){var y=this.x
if(y==null){y=new P.a3(this.gZb(),this.gZi(),0,[V.li])
this.x=y}this.z=new P.m(y,[H.f(y,0)]).B(this.gXy())}},
mN:function(d){switch(d){case C.b3:return!0
case C.b4:return!0
default:return!1}},
Zc:function(){var y,x,w
if(this.y!=null)return
y=new R.E(!0)
this.y=y
x=this.e
if(x!=null){w=x.e
if(w==null){w=new P.a3(x.gZf(),x.gLp(),0,[B.pz])
x.e=w
x=w}else x=w
y.b4(new P.m(x,[H.f(x,0)]).B(new G.Jn(this)))}y=this.y
x=J.amQ(this.gld())
y.b4(W.bS(x.a,x.b,new G.Jo(this),!1,H.f(x,0)))
y=this.y
x=J.a3Z(this.gm8())
y.b4(W.bS(x.a,x.b,new G.Jp(this),!1,H.f(x,0)))},
Zj:function(){if(this.x.d!=null)return
this.y.E()
this.y=null},
Xz:function(d){var y,x
y=this.dx
x=d.b
this.dx=y+(x==null?0:x)
if(this.db&&!0)return
this.db=!0
C.am.hk(window,new G.Jm(this,d))},
Xe:function(d,e){var y,x,w,v
for(y=J.bU(d),x=this.f;y.ad();){w=y.gaG(y)
v=x.C(0,w.target)
if(v!=null){if(!v.gfd())H.H(v.fb())
v.el(w)}}},
$icx:1}
G.Ok.prototype={
gm8:function(){return this.dy},
gw9:function(){var y=this.dy
y.toString
return"scrollY" in y?C.u.aQ(y.scrollY):C.u.aQ(y.document.documentElement.scrollTop)},
m7:function(d){var y=this.dy
C.am.HT(y,(y&&C.am).gwa(y),d)
this.d.me()},
gw8:function(d){var y,x
y=this.dy
x=!!J.L(y.document).$ijk?C.u.aQ(H.eE(y.document,"$ijk").body.scrollHeight):0
return Math.max(x,C.u.aQ(y.document.documentElement.scrollHeight))},
gui:function(d){return this.dy.document.documentElement.clientHeight},
gEY:function(d){return this.dy.document.documentElement.clientWidth},
gld:function(){return this.dy.document.documentElement},
gGY:function(){return this.fr},
gGZ:function(){return this.fx}}
Z.qh.prototype={$ili:1}
V.li.prototype={}
V.Jl.prototype={$icx:1}
V.uk.prototype={
I:function(d){return this.b}}
R.JS.prototype={
Io:function(d,e,f,g,h){var y,x,w
y=this.f
x=y.C(0,d)
if(x!=null)if(x.b===e){w=x.c
w=(w==null?f==null:w===f)&&!0}else w=!1
else w=!1
if(w)return
this.vY(d)
y.w(0,d,new R.kF(d,e,f,g,h))
this.Zd()},
vY:function(d){var y,x,w,v
this.x=null
y=this.f
x=y.bm(0,d)
if(x==null)return
w=this.y
if(w!=null){v=w.b
if(v!=null)C.e.bm(v,x)
v=w.c
if(v!=null)C.e.bm(v,x)
w=w.d
if(w!=null)C.e.bm(w,x)}x.wr()
if(x.x!==""){w=x.a.style
w.position=""
x.x=""}if(y.gb7(y)){y=this.e
if(y!=null){y.au(0)
this.e=null}}},
me:function(){var y=this.f
if(y.gbR(y))this.xg()},
ga2I:function(){var y=this.c
if(y==null){y=new P.x(null,null,0,[P.G])
this.c=y}return new P.m(y,[H.f(y,0)])},
E:function(){var y,x,w
y=this.f
if(y.gbR(y)){x=P.c9(y.gbU(y),!0,W.ar)
for(y=x.length,w=0;w<x.length;x.length===y||(0,H.aB)(x),++w)this.vY(x[w])}y=this.c
if(y!=null)y.bn(0)},
YB:function(){this.a.cN(new R.JU())},
Zd:function(){if(this.e!=null)return
this.e=this.a.goT().B(new R.JV(this))
this.b.Im()
this.YB()},
Ls:function(){var y,x,w,v,u,t,s,r,q,p
y=this.b.ZY()
for(x=this.r,x=P.h8(x,x.r,H.f(x,0)),w=P.ad;x.ad();){v=x.d.getBoundingClientRect()
u=v.top+v.height/2
t=y.b
s=t+y.d
if(Math.abs(t-u)<Math.abs(s-u)){r=Math.max(t,v.bottom)
q=s-r
if(r!==t&&q>0)y=P.iM(y.a,r,y.c,q,w)}else{p=Math.min(s,v.top)
q=p-t
if(p!==s&&q>0)y=P.iM(y.a,t,y.c,q,w)}}return P.iM(y.a,y.b,y.c,y.d,w)},
xg:function(){var y,x,w
this.X1()
y=R.ape(this.Ls(),this.x,!1,R.kF)
if(!y.ar(0,this.y)&&this.x!=null){this.Zq(y)
x=this.c
w=x==null?null:x.d!=null
if(w===!0)x.N(0,null)}},
X1:function(){var y,x,w,v
if(this.x==null){y=this.f
y=y.gdh(y)
this.x=P.c9(y,!0,H.aA(y,"P",0))}for(y=P.ad,x=0;w=this.x,x<w.length;++x){w=w[x]
v=w.a.getBoundingClientRect()
w.f=v
w.f=P.iM((v&&C.q7).gca(v),J.lK(w.f)-w.Q,J.n9(w.f),J.jb(w.f),y)
v=w.c
w.r=v==null?null:v.getBoundingClientRect()}(w&&C.e).ws(w,new R.JT())},
Zq:function(d){var y,x,w,v,u
if(d.b!=null){y=d.a.b
for(x=0;w=d.b,x<w.length;++x){v=w[x]
w=v.a
w.GQ(y+v.b)
y+=J.jb(w.f)}}w=d.c
if(w!=null){u=d.a
y=u.b+u.d
for(x=w.length-1;x>=0;--x){v=d.c[x]
w=v.a
y-=J.jb(w.f)
w.GQ(y+v.b)}}if(d.d!=null)for(x=0;w=d.d,x<w.length;++x)w[x].wr()
this.y=d},
$icx:1,
sa_N:function(d){return this.z=d}}
R.kF.prototype={
gps:function(){return this.e},
gGz:function(){return this.b===C.cF},
wr:function(){if(this.Q===0)return
this.Q=0
if(this.y!==""||this.z!==""){var y=this.a.style
C.B.c1(y,(y&&C.B).bS(y,"transform"),"","")
y.zIndex=""}this.y=""
this.z=""},
GQ:function(d){var y,x,w,v
y=d-J.lK(this.f)
if(this.Q!==y){x=C.u.aQ(y)
this.Q=x
w="translate(0px, "+x+"px)"
v=""+$.aD8
if(this.x!=="relative"||this.y!==w||this.z!==v){x=this.a.style
x.position="relative"
C.B.c1(x,(x&&C.B).bS(x,"transform"),w,"")
x.zIndex=v
this.x="relative"
this.y=w
this.z=v}}},
I:function(d){var y=this.b
return"_StickyRow "+P.hp(P.a0(["isBottom",y===C.mU,"isTop",y===C.cF,"rowPosition",this.f,"rangePosition",this.r,"translateY",this.Q,"stickyClass",this.d],P.c,P.w))},
glU:function(){return this.f},
ga31:function(){return this.r}}
R.oj.prototype={
ar:function(d,e){var y
if(e==null)return!1
if(this!==e)y=e instanceof R.oj&&new H.bB(H.oP(this)).ar(0,new H.bB(H.oP(e)))&&J.X(this.a,e.a)&&this.b===e.b
else y=!0
return y},
gaJ:function(d){return(J.bD(this.a)^C.u.gaJ(this.b))>>>0},
I:function(d){return"_RowData{row: "+H.u(this.a)+", offsetY: "+H.u(this.b)+"}"}}
R.uj.prototype={
ar:function(d,e){if(e==null)return!1
return e instanceof R.uj&&J.X(this.a,e.a)&&this.mQ(this.b,e.b)&&this.mQ(this.c,e.c)&&this.mQ(this.d,e.d)&&this.mQ(this.e,e.e)},
mQ:function(d,e){var y,x,w
y=d==null
if(y&&e==null)return!0
if(y||e==null)return!1
if(d.length!==e.length)return!1
for(x=0;x<d.length;++x)if(!J.X(d[x],e[x])){y=d[x]
if(typeof y==="number"){w=e[x]
w=typeof w==="number"}else w=!1
if(w){if(J.a0e(y)!==J.a0e(e[x]))return!1}else return!1}return!0},
I:function(d){return"StickyContainerLayout "+P.hp(P.a0(["hostPosition",this.a,"topRows",this.b,"bottomRows",this.c,"hiddenRows",this.d,"_translateYs",this.e],P.c,P.w))}}
T.mw.prototype={}
var z=a.updateTypes([{func:1,ret:-1},{func:1,ret:-1,args:[W.de]},{func:1,ret:-1,args:[P.dd]},{func:1,ret:B.ji,args:[V.eH]},{func:1,ret:P.q,args:[B.ib]},{func:1,ret:-1,args:[V.li]},{func:1,ret:-1,args:[[P.P,,],W.nw]},{func:1,ret:P.G,args:[V.li]},{func:1,ret:P.k,args:[R.kF,R.kF]},{func:1,ret:T.mw,args:[F.dK,Y.e6,B.ji,W.fG]}])
G.a_n.prototype={
$1:function(d){return new B.ji(d)},
$S:z+3}
G.Jn.prototype={
$1:function(d){this.a.x.N(0,d)},
$S:z+7}
G.Jo.prototype={
$1:function(d){var y,x,w,v,u,t,s,r,q
if(!J.L(d).$ijL)return
u=d.ctrlKey
if(u!==!0){u=d.shiftKey
u=u===!0}else u=!0
if(u)return
y=null
x=null
try{y=C.cS.ga_z(d)
if(y==null)$.z1().k0(C.bO,"deltaX is null in event: "+H.u(d),null,null)}catch(t){u=H.aw(t)
if(!!J.L(u).$inT){w=u
$.z1().k0(C.bO,"deltaX is not supported in event: "+H.u(d),w,null)}else throw t}if(y==null)y=0
try{x=C.cS.ga_A(d)
if(x==null)$.z1().k0(C.bO,"deltaY is null in event: "+H.u(d),null,null)}catch(t){u=H.aw(t)
if(!!J.L(u).$inT){v=u
$.z1().k0(C.bO,"deltaY is not supported in event: "+H.u(d),v,null)}else throw t}if(x==null)x=0
s=B.ah2(y,J.amr(x))
if(J.X(x,0)||!this.a.mN(s))return
u=this.a
if(B.agG(u.gld(),W.cV(d.target)).C(0,s))return
d.preventDefault()
d.stopPropagation()
r=C.cS.ga_y(d)===0?1:16
q=J.zd(x)
u.x.N(0,new Z.qh(q*r))},
$S:216}
G.Jp.prototype={
$1:function(d){var y=this.a
if(y.cy){y.cy=!1
return}y.x.N(0,new Z.qh(0))},
$S:9}
G.Jm.prototype={
$1:function(d){var y,x
y=this.a
x=y.dx
if(x!==0){y.cy=!0
y.m7(y.gw9()+x)}y.d.me()
y.db=!1
y.dx=0},
$S:7}
R.JU.prototype={
$0:function(){},
$S:0}
R.JV.prototype={
$1:function(d){this.a.xg()},
$S:2}
R.JT.prototype={
$2:function(d,e){return C.u.c2(J.lK(d.f),J.lK(e.f))},
$S:z+8}
R.a_m.prototype={
$4:function(d,e,f,g){var y=new T.mw(g,d,e,P.e(W.ar,[P.qk,W.m0]),!1)
y.px(d,e,f,!1)
return y},
$C:"$4",
$R:4,
$S:z+9};(function installTearOffs(){var y=a._instance_0u,x=a._instance_1u,w=a._instance_2u
var v
y(v=B.to.prototype,"gZf","Zg",0)
y(v,"gLp","Lq",0)
x(v,"gXO","De",1)
x(v,"gXM","XN",1)
x(v,"gXK","XL",1)
x(v=B.wa.prototype,"gJX","JY",2)
x(v,"gK_","K0",2)
x(v=G.qg.prototype,"gz1","mN",4)
y(v,"gZb","Zc",0)
y(v,"gZi","Zj",0)
x(v,"gXy","Xz",5)
w(v,"gXd","Xe",6)})();(function inheritance(){var y=a.inheritMany,x=a.inherit
y(P.w,[B.ib,B.ji,Z.qh,B.to,B.wa,K.HO,M.a1C,G.qg,V.li,V.Jl,V.uk,R.JS,R.kF,R.oj,R.uj])
x(B.pz,Z.qh)
y(H.aS,[G.a_n,G.Jn,G.Jo,G.Jp,G.Jm,R.JU,R.JV,R.JT,R.a_m])
x(G.Ok,G.qg)
x(T.mw,G.Ok)})();(function constants(){var y=a.makeConstList
C.j2=new P.bN(17e3)
C.b3=new B.ib("GestureDirection.up")
C.b4=new B.ib("GestureDirection.down")
C.bA=new B.ib("GestureDirection.left")
C.bB=new B.ib("GestureDirection.right")
C.kR=H.b(y([C.a2]),[P.w])
C.au=H.b(y([C.kR]),[[P.o,P.w]])
C.bI=H.v(B.ji)
C.kT=H.b(y([C.bI]),[P.w])
C.lO=H.b(y([C.bQ,C.bD,C.kT,C.cp]),[[P.o,P.w]])
C.cF=new V.uk("StickyPosition.TOP")
C.mU=new V.uk("StickyPosition.BOTTOM")
C.c3=H.v(V.Jl)
C.h1=H.v(T.mw)})();(function staticFields(){$.abp=!1
$.abo=!1
$.abn=!1
$.abk=!1
$.abm=!1
$.aD8=100
$.abi=!1
$.abh=!1
$.abl=!1
$.abf=!1
$.abg=!1})();(function lazyInitializers(){var y=a.lazy
y($,"aLG","z1",function(){return N.tC("ScrollHostBase")})
y($,"aMV","aiE",function(){var x=W.a30().matchMedia("(pointer: coarse)").matches
return x===!0||$.z3().oE("__acxForceTouchEnabled")})
y($,"aQU","amm",function(){return $.z3().oE("IntersectionObserver")})})()}
$__dart_deferred_initializers__["O1CP7/h3TR+FQvNLoA7wkDNJP+M="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_37.part.js.map
