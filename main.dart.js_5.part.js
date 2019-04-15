self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P,W,G,Y,R,K,V,S,N,E,M,Q={
cj:function(d,e){var y,x=new Q.uO(d,S.i(1,C.i,e)),w=$.a6G
if(w==null)w=$.a6G=O.O($.aAJ,null)
x.c=w
y=document.createElement("material-toggle")
x.a=y
x.M(y,"themeable")
return x},
aHN:function(d,e){var y=new Q.Vk(N.G(),d,S.i(3,C.c,e))
y.c=d.c
return y},
aHO:function(d,e){return new Q.Vl(d,S.i(3,C.j,e))},
mK:function(){if($.ab8)return
$.ab8=!0
$.H.C(0,C.os,C.ix)
E.B()
V.fR()
K.cR()},
uO:function uO(d,e){var _=this
_.c=_.b=_.a=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Vk:function Vk(d,e,f){var _=this
_.f=d
_.c=_.b=_.a=null
_.d=e
_.e=f},
Vl:function Vl(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e}},D={
ce:function(d,e){return new D.hf(d,new P.a7(null,null,[P.v]))},
hf:function hf(d,e){var _=this
_.a=null
_.b=d
_.c=null
_.e=_.d=!1
_.f=e
_.r=null
_.y=1
_.Q=_.z=!1},
FD:function FD(d){this.a=d}},L,Z,O,A,U,T,X,B,F
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
O=c[18]
A=c[19]
U=c[20]
T=c[21]
X=c[22]
B=c[23]
F=c[24]
D.hf.prototype={
sbD:function(d,e){this.e=e
this.bh()},
gff:function(){var y=this.r
return y},
nJ:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
lB:function(){var y,x=this
if(!x.d){x.e=!x.e
x.bh()
x.f.O(0,x.e)
y=x.a
if(y!=null)y.$0()}},
e3:function(d){this.lB()
d.preventDefault()
d.stopPropagation()},
iM:function(d){if(d.keyCode===13||Z.iq(d)){this.lB()
d.preventDefault()
d.stopPropagation()}},
bh:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.x(this.e))},
eT:function(d,e){var y
this.e=e
this.bh()
y=this.b
if(y!=null)y.ao()},
eP:function(d){var y=this.f
new P.p(y,[H.f(y,0)]).B(new D.FD(d))},
hR:function(d){this.a=d},
e5:function(d){var y
this.d=d
y=this.b
if(y!=null)y.ao()},
sbM:function(d,e){return this.d=e}}
Q.uO.prototype={
p:function(){var y,x,w,v=this,u="animated",t=v.b,s=v.a,r=v.a_(s),q=document,p=T.t(q,r)
v.dy=p
v.A(p,"material-toggle")
T.d(v.dy,"role","button")
v.h(v.dy)
p=v.f=new V.q(1,0,v,T.E(v.dy))
v.r=new K.D(new D.w(p,Q.awU()),p)
y=T.t(q,v.dy)
v.A(y,"tgl-container")
v.h(y)
p=T.t(q,y)
v.fr=p
T.d(p,u,"")
v.A(v.fr,"tgl-bar")
v.h(v.fr)
x=T.t(q,y)
v.A(x,"tgl-btn-container")
v.h(x)
p=T.t(q,x)
v.fx=p
v.A(p,"tgl-btn-underlay")
v.h(v.fx)
p=T.t(q,v.fx)
v.fy=p
T.d(p,u,"")
v.A(v.fy,"tgl-btn")
v.h(v.fy)
v.br(v.fy,0)
p=v.dy
w=W.F;(p&&C.D).S(p,"blur",v.u(v.gKK(),w,w))
p=v.dy;(p&&C.D).S(p,"focus",v.u(v.gNj(),w,w))
p=v.dy;(p&&C.D).S(p,"mouseenter",v.u(v.gNZ(),w,w))
p=v.dy;(p&&C.D).S(p,"mouseleave",v.u(v.gO2(),w,w))
t.c=v.dy
v.ae()
p=J.af(s)
p.S(s,"click",v.u(t.gcu(),w,W.ax))
p.S(s,"keypress",v.u(t.gcb(),w,W.a2))},
q:function(){var y,x,w,v,u,t,s,r,q,p=this,o="elevation",n=p.b,m=p.r,l=n.r
m.sT(l!=null&&l.length!==0)
p.f.H()
y=n.e
m=p.x
if(m!=y){T.a5(p.dy,"checked",y)
p.x=y}x=n.d
m=p.y
if(m!=x){T.a5(p.dy,"disabled",x)
p.y=x}w=n.d?"-1":"0"
m=p.z
if(m!==w){m=p.dy
T.I(m,"tabindex",w)
p.z=w}v=O.ad(n.d)
m=p.Q
if(m!==v){T.d(p.dy,"aria-disabled",v)
p.Q=v}u=n.gff()
if(u==null)u=""
m=p.ch
if(m!==u){T.d(p.dy,"aria-label",u)
p.ch=u}t=O.ad(n.y)
m=p.cx
if(m!==t){T.d(p.fr,o,t)
p.cx=t}s=n.e
m=p.cy
if(m!=s){T.a5(p.fx,"under-checked",s)
p.cy=s}r=n.z
m=p.db
if(m!==r){T.a5(p.fx,"under-focus",r)
p.db=r}q=O.ad(n.y)
m=p.dx
if(m!==q){T.d(p.fy,o,q)
p.dx=q}},
v:function(){this.f.G()},
KL:function(d){var y=this.b
y.z=!1
y.nJ()},
Nk:function(d){var y=this.b
y.z=!0
y.nJ()},
O_:function(d){var y=this.b
y.Q=!0
y.nJ()},
O3:function(d){var y=this.b
y.Q=!1
y.nJ()},
$ac:function(){return[D.hf]}}
Q.Vk.prototype={
p:function(){var y=this,x=document.createElement("div")
y.A(x,"tgl-lbl")
y.h(x)
x.appendChild(y.f.b)
y.E(x)},
q:function(){var y=this.b.r
if(y==null)y=""
this.f.V(y)},
$ac:function(){return[D.hf]}}
Q.Vl.prototype={
p:function(){var y=this,x=y.f=Q.cj(y,0)
y.a=x.a
x=D.ce(x,null)
y.r=x
y.f.m(0,x,y.e.e)
y.E(y.a)
return new D.C(y,0,y.a,y.r,[D.hf])},
N:function(d,e,f){if(d===C.d&&0===e)return this.r
return f},
q:function(){var y=this.e.cx
this.f.i()
if(y===0)this.r.bh()},
v:function(){this.f.j()},
$ac:function(){return[D.hf]}}
var z=a.updateTypes([{func:1,ret:-1,args:[,]},{func:1,ret:-1,args:[W.ax]},{func:1,ret:-1,args:[W.a2]},{func:1,ret:-1,args:[P.v]},{func:1,ret:[S.c,-1],args:[[S.c,,],P.l]},{func:1,ret:[S.c,D.hf],args:[[S.c,,],P.l]}])
D.FD.prototype={
$1:function(d){return this.a.$1(d)},
$S:48};(function installTearOffs(){var y=a._instance_1u,x=a._static_2
var w
y(w=D.hf.prototype,"gcu","e3",1)
y(w,"gcb","iM",2)
y(w,"ghL","e5",3)
x(Q,"awU","aHN",4)
x(Q,"awV","aHO",5)
y(w=Q.uO.prototype,"gKK","KL",0)
y(w,"gNj","Nk",0)
y(w,"gNZ","O_",0)
y(w,"gO2","O3",0)})();(function inheritance(){var y=a.inherit,x=a.inheritMany
y(D.hf,P.m)
y(D.FD,H.aW)
x(S.c,[Q.uO,Q.Vk,Q.Vl])})();(function constants(){C.ix=new D.A("material-toggle",Q.awV(),[D.hf])
C.os=H.y(D.hf)})();(function staticFields(){$.aBS=['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px;overflow:visible}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px;color:#009688}.tgl-btn-underlay._ngcontent-%ID%{width:40px;height:40px;border-radius:50%;margin:-10px}.tgl-btn-underlay.under-focus._ngcontent-%ID%{background-color:rgba(188,188,188,0.24)}.tgl-btn-underlay.under-focus.under-checked._ngcontent-%ID%{background-color:rgba(0,150,136,0.24)}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);margin:10px;background-color:#fafafa;opacity:1;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']
$.a6G=null
$.ab8=!1
$.aAJ=[$.aBS]})()}
$__dart_deferred_initializers__["DxcHazbMFEORENwhpJBF2vfZy4Y="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_5.part.js.map
