self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P,W,G,Y,R,K,V,S,N,E,M,Q={
cm:function(d,e){var y,x
y=new Q.vs(P.e(P.c,null),d)
y.a=S.i(y,1,C.j,e,D.eR)
x=document.createElement("material-toggle")
y.e=x
x.className="themeable"
x=$.a1k
if(x==null){x=$.D
x=x.Y(null,C.m,$.aka())
$.a1k=x}y.X(x)
return y},
aHU:function(d,e){var y=new Q.VY(P.e(P.c,null),d)
y.a=S.i(y,3,C.c,e,D.eR)
y.d=$.a1k
return y},
aHV:function(d,e){var y=new Q.VZ(P.e(P.c,null),d)
y.a=S.i(y,3,C.k,e,D.eR)
return y},
mW:function(){if($.ab_)return
$.ab_=!0
$.F().w(0,C.p2,C.iq)
E.z()
V.fJ()
K.cX()},
vs:function vs(d,e){var _=this
_.a=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
VY:function VY(d,e){var _=this
_.a=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
VZ:function VZ(d,e){var _=this
_.a=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null}},D={
cj:function(d,e){return new D.eR(d,new P.a3(null,null,0,[P.q]))},
eR:function eR(d,e){var _=this
_.a=null
_.b=d
_.c=null
_.e=_.d=!1
_.f=e
_.x=_.r=null
_.y=1
_.Q=_.z=!1},
Gw:function Gw(d){this.a=d}},L,Z,A,U,T,O,X,B,F
a.setFunctionNamesIfNecessary([Q,D])
C=c[0]
H=c[1]
J=c[2]
P=c[3]
W=c[4]
G=c[5]
Y=c[6]
R=c[7]
K=c[8]
V=c[9]
S=c[10]
N=c[11]
E=c[12]
M=c[13]
Q=a.updateHolder(c[14],Q)
D=a.updateHolder(c[15],D)
L=c[16]
Z=c[17]
A=c[18]
U=c[19]
T=c[20]
O=c[21]
X=c[22]
B=c[23]
F=c[24]
D.eR.prototype={
sbH:function(d,e){this.e=e
this.bf()},
o4:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
lW:function(){if(!this.d){this.e=!this.e
this.bf()
this.f.N(0,this.e)
var y=this.a
if(y!=null)y.$0()}},
eM:function(d){this.lW()
d.preventDefault()
d.stopPropagation()},
hb:function(d){if(d.keyCode===13||Z.j6(d)){this.lW()
d.preventDefault()
d.stopPropagation()}},
bf:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.u(this.e))},
eX:function(d,e){this.e=e
this.bf()
this.b.a.ao()},
eT:function(d){var y=this.f
new P.m(y,[H.f(y,0)]).B(new D.Gw(d))},
hZ:function(d){this.a=d},
e5:function(d){this.d=d
this.b.a.ao()},
gaY:function(d){return this.d},
saY:function(d,e){return this.d=e}}
Q.vs.prototype={
p:function(){var y,x,w,v,u,t,s,r
y=this.f
x=this.e
w=this.Z(x)
v=document
u=S.p(v,w)
this.dx=u
u.className="material-toggle"
u.setAttribute("role","button")
this.h(this.dx)
u=$.J().cloneNode(!1)
this.dx.appendChild(u)
u=new V.n(1,0,this,u)
this.r=u
this.x=new K.B(new D.t(u,Q.aAj()),u)
t=S.p(v,this.dx)
t.className="tgl-container"
this.h(t)
u=S.p(v,t)
this.dy=u
u.setAttribute("animated","")
u=this.dy
u.className="tgl-bar"
this.h(u)
s=S.p(v,t)
s.className="tgl-btn-container"
this.h(s)
u=S.p(v,s)
this.fr=u
u.setAttribute("animated","")
u=this.fr
u.className="tgl-btn"
this.h(u)
this.bs(this.fr,0)
u=this.dx
r=W.C;(u&&C.C).P(u,"blur",this.u(this.gLE(),r,r))
u=this.dx;(u&&C.C).P(u,"focus",this.u(this.gO3(),r,r))
u=this.dx;(u&&C.C).P(u,"mouseenter",this.u(this.gON(),r,r))
u=this.dx;(u&&C.C).P(u,"mouseleave",this.u(this.gOR(),r,r))
this.f.c=this.dx
this.J(C.a,null)
u=J.V(x)
u.P(x,"click",this.u(y.gcc(),r,W.an))
u.P(x,"keypress",this.u(y.gc3(),r,W.Z))},
q:function(){var y,x,w,v,u,t,s,r,q,p
y=this.f
x=this.x
w=y.r
x.sU(w!=null&&w.length!==0)
this.r.G()
v=y.e
x=this.y
if(x!=v){this.al(this.dx,"checked",v)
this.y=v}u=y.d
x=this.z
if(x!=u){this.al(this.dx,"disabled",u)
this.z=u}t=y.d?"-1":"0"
x=this.Q
if(x!==t){x=this.dx
this.a3(x,"tabindex",t)
this.Q=t}s=Q.I(y.d)
x=this.ch
if(x!==s){this.a3(this.dx,"aria-disabled",J.bV(s))
this.ch=s}x=y.x
r=x==null?y.r:x
if(r==null)r=""
x=this.cx
if(x!==r){this.a3(this.dx,"aria-label",r)
this.cx=r}q=Q.I(y.y)
x=this.cy
if(x!==q){this.a3(this.dy,"elevation",J.bV(q))
this.cy=q}p=Q.I(y.y)
x=this.db
if(x!==p){this.a3(this.fr,"elevation",J.bV(p))
this.db=p}},
v:function(){this.r.F()},
LF:function(d){var y=this.f
y.z=!1
y.o4()},
O4:function(d){var y=this.f
y.z=!0
y.o4()},
OO:function(d){var y=this.f
y.Q=!0
y.o4()},
OS:function(d){var y=this.f
y.Q=!1
y.o4()},
$aa:function(){return[D.eR]}}
Q.VY.prototype={
p:function(){var y,x,w
y=document
x=y.createElement("div")
x.className="tgl-lbl"
this.h(x)
w=y.createTextNode("")
this.x=w
x.appendChild(w)
this.D(x)},
q:function(){var y,x
y=this.f.r
if(y==null)y=""
x=this.r
if(x!==y){this.x.textContent=y
this.r=y}},
$aa:function(){return[D.eR]}}
Q.VZ.prototype={
p:function(){var y=Q.cm(this,0)
this.r=y
this.e=y.e
y=D.cj(y.a.b,null)
this.x=y
this.r.k(0,y,this.a.e)
this.D(this.e)
return new D.A(this,0,this.e,this.x,[D.eR])},
K:function(d,e,f){if(d===C.d&&0===e)return this.x
return f},
q:function(){var y=this.a.cy
this.r.j()
if(y===0)this.x.bf()},
v:function(){this.r.i()},
$aa:function(){return[D.eR]}}
var z=a.updateTypes([{func:1,ret:-1,args:[,]},{func:1,ret:[S.a,D.eR],args:[[S.a,,],P.k]},{func:1,ret:-1,args:[W.an]},{func:1,ret:-1,args:[W.Z]},{func:1,ret:-1,args:[P.q]}])
D.Gw.prototype={
$1:function(d){return this.a.$1(d)},
$S:212};(function installTearOffs(){var y=a._instance_1u,x=a._static_2
var w
y(w=D.eR.prototype,"gcc","eM",2)
y(w,"gc3","hb",3)
y(w,"ghS","e5",4)
x(Q,"aAj","aHU",1)
x(Q,"aAk","aHV",1)
y(w=Q.vs.prototype,"gLE","LF",0)
y(w,"gO3","O4",0)
y(w,"gON","OO",0)
y(w,"gOR","OS",0)})();(function inheritance(){var y=a.inherit,x=a.inheritMany
y(D.eR,P.w)
y(D.Gw,H.aS)
x(S.a,[Q.vs,Q.VY,Q.VZ])})();(function constants(){C.iq=new D.y("material-toggle",Q.aAk(),[D.eR])
C.p2=H.v(D.eR)})();(function staticFields(){$.a1k=null
$.ab_=!1})();(function lazyInitializers(){var y=a.lazy
y($,"aQK","alj",function(){return['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);background-color:#fafafa;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']})
y($,"aOy","aka",function(){return[$.alj()]})})()}
$__dart_deferred_initializers__["AQMRcWWHpUUuZny06+7GnKqlXrQ="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_5.part.js.map
