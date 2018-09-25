self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,d,e,f,g,h,i,j,k,l,m,$){var C={},H={},J={},P={},W={},G={},Y={},R={},K={},V={},S={},N={},E={},M={},B={},Q={
c0:function(n,o){var x,w
x=new Q.ve(P.e(P.c,null),n)
x.a=S.f(x,1,C.j,o)
w=document.createElement("material-toggle")
x.e=w
w.className="themeable"
w=$.a1p
if(w==null){w=$.D
w=w.a2(null,C.p,$.$get$aiN())
$.a1p=w}x.a1(w)
return x},
aHo:function(n,o){var x=new Q.W4(P.e(P.c,null),n)
x.a=S.f(x,3,C.b,o)
x.d=$.a1p
return x},
aHp:function(n,o){var x=new Q.W5(P.e(P.c,null),n)
x.a=S.f(x,3,C.k,o)
return x},
m0:function(){if($.abn)return
$.abn=!0
$.$get$F().u(0,C.o6,C.hP)
E.w()
V.fE()
K.cC()},
ve:function ve(n,o){var _=this
_.a=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=n
_.c=o
_.f=_.e=_.d=null},
W4:function W4(n,o){var _=this
_.a=_.y=_.x=_.r=null
_.b=n
_.c=o
_.f=_.e=_.d=null},
W5:function W5(n,o){var _=this
_.a=_.x=_.r=null
_.b=n
_.c=o
_.f=_.e=_.d=null}},D={
bW:function(n,o){return new D.fY(n,!1,!1,new P.a0(null,null,0,[P.x]),1,!1,!1)},
fY:function fY(n,o,p,q,r,s,t){var _=this
_.a=null
_.b=n
_.c=null
_.d=o
_.e=p
_.f=q
_.x=_.r=null
_.y=r
_.z=s
_.Q=t},
H5:function H5(n){this.a=n}},L={},Z={},A={},U={},T={},O={},X={},F={}
var z=[C,H,J,P,W,G,Y,R,K,V,S,N,E,M,B,Q,D,L,Z,A,U,T,O,X,F]
g([C,H,J,P,W,G,Y,R,K,V,S,N,E,M,B,Q,D,L,Z,A,U,T,O,X,F])
C=h(m[0],C)
H=h(m[1],H)
J=h(m[2],J)
P=h(m[3],P)
W=h(m[4],W)
G=h(m[5],G)
Y=h(m[6],Y)
R=h(m[7],R)
K=h(m[8],K)
V=h(m[9],V)
S=h(m[10],S)
N=h(m[11],N)
E=h(m[12],E)
M=h(m[13],M)
B=h(m[14],B)
Q=h(m[15],Q)
D=h(m[16],D)
L=h(m[17],L)
Z=h(m[18],Z)
A=h(m[19],A)
U=h(m[20],U)
T=h(m[21],T)
O=h(m[22],O)
X=h(m[23],X)
F=h(m[24],F)
D.fY.prototype={
scm:function(n,o){this.e=o
this.ce()},
gcm:function(n){return this.e},
sJj:function(n){this.z=n
this.Hn()},
sJD:function(n){this.Q=n
this.Hn()},
Hn:function(){if(this.Q)var x=3
else x=this.z?2:1
this.y=x},
o0:function(){if(!this.d){this.e=!this.e
this.ce()
this.f.S(0,this.e)
var x=this.a
if(!(x==null))x.$0()}},
i_:function(n){this.o0()
n.preventDefault()
n.stopPropagation()},
kU:function(n){if(n.keyCode===13||Z.jj(n)){this.o0()
n.preventDefault()
n.stopPropagation()}},
ce:function(){var x=this.c
if(x==null)return
x.setAttribute("aria-pressed",H.u(this.e))},
ia:function(n,o){this.e=o
this.ce()
this.b.a.aS()},
i6:function(n){var x=this.f
new P.l(x,[H.i(x,0)]).B(new D.H5(n))},
k7:function(n){this.a=n},
h5:function(n){this.d=n
this.b.a.aS()},
gaR:function(n){return this.d},
gd_:function(n){return this.r},
sa7b:function(n){return this.c=n},
saR:function(n,o){return this.d=o},
sd_:function(n,o){return this.r=o}}
Q.ve.prototype={
p:function(){var x,w,v,u,t,s
x=this.f
w=this.e
v=this.a3(w)
u=document
t=S.o(u,v)
this.r=t
t.className="material-toggle"
t.setAttribute("role","button")
this.h(this.r)
t=$.$get$I().cloneNode(!1)
this.r.appendChild(t)
t=new V.n(1,0,this,t)
this.x=t
this.y=new K.A(new D.p(t,Q.azl()),t,!1)
t=S.o(u,this.r)
this.z=t
t.className="tgl-container"
this.h(t)
t=S.o(u,this.z)
this.Q=t
t.setAttribute("animated","")
t=this.Q
t.className="tgl-bar"
this.h(t)
t=S.o(u,this.z)
this.ch=t
t.className="tgl-btn-container"
this.h(t)
t=S.o(u,this.ch)
this.cx=t
t.setAttribute("animated","")
t=this.cx
t.className="tgl-btn"
this.h(t)
this.cB(this.cx,0)
t=this.r
s=W.B;(t&&C.u).a7(t,"blur",this.w(this.gOO(),s,s))
t=this.r;(t&&C.u).a7(t,"focus",this.w(this.gRf(),s,s))
t=this.r;(t&&C.u).a7(t,"mouseenter",this.w(this.gS2(),s,s))
t=this.r;(t&&C.u).a7(t,"mouseleave",this.w(this.gS6(),s,s))
this.f.sa7b(this.r)
this.P(C.a,null)
t=J.K(w)
t.a7(w,"click",this.w(x.gdG(),s,W.a8))
t.a7(w,"keypress",this.w(x.gdB(),s,W.X))
return},
q:function(){var x,w,v,u,t,s,r,q,p,o
x=this.f
w=this.y
v=x.r
w.sZ(v!=null&&v.length!==0)
this.x.H()
u=x.e
w=this.cy
if(w==null?u!=null:w!==u){this.aG(this.r,"checked",u)
this.cy=u}t=x.d
w=this.db
if(w==null?t!=null:w!==t){this.aG(this.r,"disabled",t)
this.db=t}s=x.d?"-1":"0"
w=this.dx
if(w!==s){w=this.r
this.a9(w,"tabindex",s)
this.dx=s}r=Q.H(x.d)
w=this.dy
if(w!==r){w=this.r
v=J.bG(r)
this.a9(w,"aria-disabled",v)
this.dy=r}w=x.x
q=w==null?x.r:w
if(q==null)q=""
w=this.fr
if(w!==q){w=this.r
this.a9(w,"aria-label",q)
this.fr=q}p=Q.H(x.y)
w=this.fx
if(w!==p){w=this.Q
v=J.bG(p)
this.a9(w,"elevation",v)
this.fx=p}o=Q.H(x.y)
w=this.fy
if(w!==o){w=this.cx
v=J.bG(o)
this.a9(w,"elevation",v)
this.fy=o}},
v:function(){var x=this.x
if(!(x==null))x.G()},
OP:function(n){this.f.sJj(!1)},
Rg:function(n){this.f.sJj(!0)},
S3:function(n){this.f.sJD(!0)},
S7:function(n){this.f.sJD(!1)},
$asb:function(){return[D.fY]}}
Q.W4.prototype={
p:function(){var x,w
x=document
w=x.createElement("div")
this.r=w
w.className="tgl-lbl"
this.h(w)
w=x.createTextNode("")
this.x=w
this.r.appendChild(w)
this.E(this.r)
return},
q:function(){var x,w
x=this.f.r
if(x==null)x=""
w=this.y
if(w!==x){this.x.textContent=x
this.y=x}},
$asb:function(){return[D.fY]}}
Q.W5.prototype={
p:function(){var x=Q.c0(this,0)
this.r=x
this.e=x.e
x=D.bW(x.a.b,null)
this.x=x
this.r.k(0,x,this.a.e)
this.E(this.e)
return new D.z(this,0,this.e,this.x,[D.fY])},
R:function(n,o,p){if(n===C.c&&0===o)return this.x
return p},
q:function(){var x=this.a.cy
this.r.j()
if(x===0)this.x.ce()},
v:function(){var x=this.r
if(!(x==null))x.i()},
$asb:function(){return[D.fY]}}
var y=i([{func:1,ret:-1,args:[,]},{func:1,ret:[S.b,D.fY],args:[[S.b,,],P.j]},{func:1,ret:-1,args:[W.a8]},{func:1,ret:-1,args:[W.X]},{func:1,ret:-1,args:[P.x]}])
D.H5.prototype={
$1:function(n){return this.a.$1(n)},
"call*":"$1",
$R:1};(function installTearOffs(){var x
f(x=D.fY.prototype,"gdG",0,0,0,null,["$1"],["i_"],2,0)
f(x,"gdB",0,0,0,null,["$1"],["kU"],3,0)
f(x,"gk6",0,0,1,null,["$1"],["h5"],4,0)
f(Q,"azl",1,0,0,null,["$2"],["aHo"],1,0)
f(Q,"azm",1,0,0,null,["$2"],["aHp"],1,0)
f(x=Q.ve.prototype,"gOO",0,0,0,null,["$1"],["OP"],0,0)
f(x,"gRf",0,0,0,null,["$1"],["Rg"],0,0)
f(x,"gS2",0,0,0,null,["$1"],["S3"],0,0)
f(x,"gS6",0,0,0,null,["$1"],["S7"],0,0)})();(function inheritance(){a(D.fY,P.q)
a(D.H5,H.aE)
var x=S.b
a(Q.ve,x)
a(Q.W4,x)
a(Q.W5,x)})();(function constants(){C.hP=new D.v("material-toggle",Q.azm(),[D.fY])
C.o6=H.r(D.fY)})();(function staticFields(){$.a1p=null
$.abn=!1})();(function lazyInitializers(){c($,"ajM","$get$ajM",function(){return['._nghost-%ID%{display:inline-block;text-align:initial;}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%;}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none;}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px;}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4, 0, 0.2, 1);transition:opacity 130ms cubic-bezier(0.4, 0, 0.2, 1);background-color:rgba(0, 0, 0, 0.26);border-radius:8px;height:14px;margin:2px 0;width:100%;}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4, 0, 0.2, 1);}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0, 0, 0, 0.14), 0 1px 10px 0 rgba(0, 0, 0, 0.12), 0 2px 4px -1px rgba(0, 0, 0, 0.2);}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0, 0, 0, 0.14), 0 1px 18px 0 rgba(0, 0, 0, 0.12), 0 3px 5px -1px rgba(0, 0, 0, 0.2);}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0, 0, 0, 0.14), 0 3px 14px 2px rgba(0, 0, 0, 0.12), 0 5px 5px -3px rgba(0, 0, 0, 0.2);}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0, 0, 0, 0.14), 0 6px 30px 5px rgba(0, 0, 0, 0.12), 0 8px 10px -5px rgba(0, 0, 0, 0.2);}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0, 0, 0, 0.14), 0 9px 46px 8px rgba(0, 0, 0, 0.12), 0 11px 15px -7px rgba(0, 0, 0, 0.2);}.material-toggle.checked._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5;}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4, 0, 0.2, 1);margin-top:-2px;position:absolute;top:0;width:20px;}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px;}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4, 0, 0.2, 1);background-color:#fafafa;border-radius:50%;height:20px;position:relative;width:20px;}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4, 0, 0.2, 1);}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0, 0, 0, 0.14), 0 1px 10px 0 rgba(0, 0, 0, 0.12), 0 2px 4px -1px rgba(0, 0, 0, 0.2);}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0, 0, 0, 0.14), 0 1px 18px 0 rgba(0, 0, 0, 0.12), 0 3px 5px -1px rgba(0, 0, 0, 0.2);}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0, 0, 0, 0.14), 0 3px 14px 2px rgba(0, 0, 0, 0.12), 0 5px 5px -3px rgba(0, 0, 0, 0.2);}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0, 0, 0, 0.14), 0 6px 30px 5px rgba(0, 0, 0, 0.12), 0 8px 10px -5px rgba(0, 0, 0, 0.2);}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0, 0, 0, 0.14), 0 9px 46px 8px rgba(0, 0, 0, 0.12), 0 11px 15px -7px rgba(0, 0, 0, 0.2);}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688;}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal;}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54;}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd;}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0, 0, 0, 0.12);}']})
c($,"aiN","$get$aiN",function(){return[$.$get$ajM()]})})();(function nativeSupport(){j({})
k({})})()}
$__dart_deferred_initializers__["vcckTbdJ4oyk0I+GranWSjA8+lU="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_4.part.js.map
