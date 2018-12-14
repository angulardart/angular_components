self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,d,e,f,g,h,i,j,k,l,m,n,$){var C,H,J,P,W,G,Y,R,K,V,S,N,E,M,B,Q={
cv:function(o,p){var y,x
y=new Q.vI(P.e(P.c,null),o)
y.a=S.i(y,1,C.j,p,D.eY)
x=document.createElement("material-toggle")
y.e=x
x.className="themeable"
x=$.a2u
if(x==null){x=$.D
x=x.Y(null,C.o,$.$get$akF())
$.a2u=x}y.X(x)
return y},
aIr:function(o,p){var y=new Q.WR(P.e(P.c,null),o)
y.a=S.i(y,3,C.c,p,D.eY)
y.d=$.a2u
return y},
aIs:function(o,p){var y=new Q.WS(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p,D.eY)
return y},
n2:function(){if($.ad8)return
$.ad8=!0
$.$get$G().w(0,C.ov,C.i9)
E.z()
V.fQ()
K.d4()},
vI:function vI(o,p){var _=this
_.a=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
WR:function WR(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
WS:function WS(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null}},D={
cr:function(o,p){return new D.eY(o,!1,!1,new P.a3(null,null,0,[P.o]),1,!1,!1)},
eY:function eY(o,p,q,r,s,t,u){var _=this
_.a=null
_.b=o
_.c=null
_.d=p
_.e=q
_.f=r
_.x=_.r=null
_.y=s
_.z=t
_.Q=u},
H6:function H6(o){this.a=o}},L,Z,A,U,T,O,X,F
h([Q,D])
C=n[0]
H=n[1]
J=n[2]
P=n[3]
W=n[4]
G=n[5]
Y=n[6]
R=n[7]
K=n[8]
V=n[9]
S=n[10]
N=n[11]
E=n[12]
M=n[13]
B=n[14]
Q=i(n[15],Q)
D=i(n[16],D)
L=n[17]
Z=n[18]
A=n[19]
U=n[20]
T=n[21]
O=n[22]
X=n[23]
F=n[24]
D.eY.prototype={
sbv:function(o,p){this.e=p
this.bl()},
gbv:function(o){return this.e},
sId:function(o){this.z=o
this.Gb()},
sIv:function(o){this.Q=o
this.Gb()},
Gb:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
mM:function(){if(!this.d){this.e=!this.e
this.bl()
this.f.O(0,this.e)
var y=this.a
if(!(y==null))y.$0()}},
f5:function(o){this.mM()
o.preventDefault()
o.stopPropagation()},
hM:function(o){if(o.keyCode===13||Z.j9(o)){this.mM()
o.preventDefault()
o.stopPropagation()}},
bl:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.u(this.e))},
fi:function(o,p){this.e=p
this.bl()
this.b.a.ax()},
fc:function(o){var y=this.f
new P.n(y,[H.f(y,0)]).B(new D.H6(o))},
iw:function(o){this.a=o},
ej:function(o){this.d=o
this.b.a.ax()},
gb5:function(o){return this.d},
gcC:function(o){return this.r},
sa7T:function(o){return this.c=o},
sb5:function(o,p){return this.d=p},
scC:function(o,p){return this.r=p}}
Q.vI.prototype={
p:function(){var y,x,w,v,u,t,s,r
y=this.f
x=this.e
w=this.Z(x)
v=document
u=S.r(v,w)
this.dx=u
u.className="material-toggle"
u.setAttribute("role","button")
this.h(this.dx)
u=$.$get$J().cloneNode(!1)
this.dx.appendChild(u)
u=new V.p(1,0,this,u)
this.r=u
this.x=new K.C(new D.v(u,Q.aAT()),u,!1)
t=S.r(v,this.dx)
t.className="tgl-container"
this.h(t)
u=S.r(v,t)
this.dy=u
u.setAttribute("animated","")
u=this.dy
u.className="tgl-bar"
this.h(u)
s=S.r(v,t)
s.className="tgl-btn-container"
this.h(s)
u=S.r(v,s)
this.fr=u
u.setAttribute("animated","")
u=this.fr
u.className="tgl-btn"
this.h(u)
this.bx(this.fr,0)
u=this.dx
r=W.E;(u&&C.B).S(u,"blur",this.u(this.gOn(),r,r))
u=this.dx;(u&&C.B).S(u,"focus",this.u(this.gQN(),r,r))
u=this.dx;(u&&C.B).S(u,"mouseenter",this.u(this.gRs(),r,r))
u=this.dx;(u&&C.B).S(u,"mouseleave",this.u(this.gRw(),r,r))
this.f.sa7T(this.dx)
this.M(C.a,null)
u=J.M(x)
u.S(x,"click",this.u(y.gck(),r,W.am))
u.S(x,"keypress",this.u(y.gca(),r,W.Z))},
q:function(){var y,x,w,v,u,t,s,r,q,p
y=this.f
x=this.x
w=y.r
x.sU(w!=null&&w.length!==0)
this.r.H()
v=y.e
x=this.y
if(x!=v){this.aq(this.dx,"checked",v)
this.y=v}u=y.d
x=this.z
if(x!=u){this.aq(this.dx,"disabled",u)
this.z=u}t=y.d?"-1":"0"
x=this.Q
if(x!==t){x=this.dx
this.a2(x,"tabindex",t)
this.Q=t}s=Q.I(y.d)
x=this.ch
if(x!==s){this.a2(this.dx,"aria-disabled",J.bX(s))
this.ch=s}x=y.x
r=x==null?y.r:x
if(r==null)r=""
x=this.cx
if(x!==r){this.a2(this.dx,"aria-label",r)
this.cx=r}q=Q.I(y.y)
x=this.cy
if(x!==q){this.a2(this.dy,"elevation",J.bX(q))
this.cy=q}p=Q.I(y.y)
x=this.db
if(x!==p){this.a2(this.fr,"elevation",J.bX(p))
this.db=p}},
v:function(){this.r.G()},
Oo:function(o){this.f.sId(!1)},
QO:function(o){this.f.sId(!0)},
Rt:function(o){this.f.sIv(!0)},
Rx:function(o){this.f.sIv(!1)},
$asb:function(){return[D.eY]}}
Q.WR.prototype={
p:function(){var y,x,w
y=document
x=y.createElement("div")
x.className="tgl-lbl"
this.h(x)
w=y.createTextNode("")
this.x=w
x.appendChild(w)
this.E(x)},
q:function(){var y,x
y=this.f.r
if(y==null)y=""
x=this.r
if(x!==y){this.x.textContent=y
this.r=y}},
$asb:function(){return[D.eY]}}
Q.WS.prototype={
p:function(){var y=Q.cv(this,0)
this.r=y
this.e=y.e
y=D.cr(y.a.b,null)
this.x=y
this.r.k(0,y,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[D.eY])},
N:function(o,p,q){if(o===C.d&&0===p)return this.x
return q},
q:function(){var y=this.a.cy
this.r.j()
if(y===0)this.x.bl()},
v:function(){this.r.i()},
$asb:function(){return[D.eY]}}
var z=j([{func:1,ret:-1,args:[,]},{func:1,ret:[S.b,D.eY],args:[[S.b,,],P.k]},{func:1,ret:-1,args:[W.am]},{func:1,ret:-1,args:[W.Z]},{func:1,ret:-1,args:[P.o]}])
D.H6.prototype={
$1:function(o){return this.a.$1(o)},
"call*":"$1",
$R:1,
$S:217};(function installTearOffs(){var y
g(y=D.eY.prototype,"gck",0,0,0,null,["$1"],["f5"],2,0)
g(y,"gca",0,0,0,null,["$1"],["hM"],3,0)
g(y,"git",0,0,1,null,["$1"],["ej"],4,0)
g(Q,"aAT",1,0,0,null,["$2"],["aIr"],1,0)
g(Q,"aAU",1,0,0,null,["$2"],["aIs"],1,0)
g(y=Q.vI.prototype,"gOn",0,0,0,null,["$1"],["Oo"],0,0)
g(y,"gQN",0,0,0,null,["$1"],["QO"],0,0)
g(y,"gRs",0,0,0,null,["$1"],["Rt"],0,0)
g(y,"gRw",0,0,0,null,["$1"],["Rx"],0,0)})();(function inheritance(){var y=a,x=b
y(D.eY,P.t)
y(D.H6,H.aS)
x(S.b,[Q.vI,Q.WR,Q.WS])})();(function constants(){C.i9=new D.y("material-toggle",Q.aAU(),[D.eY])
C.ov=H.x(D.eY)})();(function staticFields(){$.a2u=null
$.ad8=!1})();(function lazyInitializers(){d($,"alL","$get$alL",function(){return['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);background-color:#fafafa;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']})
d($,"akF","$get$akF",function(){return[$.$get$alL()]})})()}
$__dart_deferred_initializers__["UUPxjdAi8XQr41jX1pU1KN99kEo="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_3.part.js.map
