self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P,W,G,Y,R,K,V,S,E,M,Q={
ce:function(d,e){var y,x=new Q.uO(d,S.h(1,C.i,e)),w=$.a6M
if(w==null)w=$.a6M=O.O($.aAS,null)
x.c=w
y=document.createElement("material-toggle")
x.a=y
x.M(y,"themeable")
return x},
aHW:function(d,e){var y=new Q.Vs(N.G(),d,S.h(3,C.c,e))
y.c=d.c
return y},
aHX:function(){return new Q.Vt(null,S.h(3,C.j,null))},
mL:function(){if($.abf)return
$.abf=!0
$.H.C(0,C.or,C.iw)
E.A()
V.eS()
K.cJ()},
uO:function uO(d,e){var _=this
_.c=_.b=_.a=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Vs:function Vs(d,e,f){var _=this
_.f=d
_.c=_.b=_.a=null
_.d=e
_.e=f},
Vt:function Vt(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e}},D={
ca:function(d,e){return new D.j8(d,new P.a7(null,null,[P.u]))},
j8:function j8(d,e){var _=this
_.a=null
_.b=d
_.c=null
_.e=_.d=!1
_.f=e
_.r=null
_.y=1
_.Q=_.z=!1},
FI:function FI(d){this.a=d}},L,Z,O,B,A,U,T,N,X,F
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
E=c[11]
M=c[12]
Q=a.updateHolder(c[13],Q)
D=a.updateHolder(c[14],D)
L=c[15]
Z=c[16]
O=c[17]
B=c[18]
A=c[19]
U=c[20]
T=c[21]
N=c[22]
X=c[23]
F=c[24]
D.j8.prototype={
gfg:function(){var y=this.r
return y},
nH:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
ly:function(){var y,x=this
if(!x.d){x.e=!x.e
x.bk()
x.f.P(0,x.e)
y=x.a
if(y!=null)y.$0()}},
e4:function(d){this.ly()
d.preventDefault()
d.stopPropagation()},
iL:function(d){if(d.keyCode===13||Z.hl(d)){this.ly()
d.preventDefault()
d.stopPropagation()}},
bk:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.w(this.e))},
eW:function(d,e){var y
this.e=e
this.bk()
y=this.b
if(y!=null)y.ao()},
eS:function(d){var y=this.f
new P.o(y,[H.e(y,0)]).B(new D.FI(d))},
hQ:function(d){this.a=d},
e6:function(d){var y
this.d=d
y=this.b
if(y!=null)y.ao()}}
Q.uO.prototype={
p:function(){var y,x,w,v=this,u="animated",t=v.b,s=v.a0(),r=document,q=T.r(r,s)
v.dy=q
v.A(q,"material-toggle")
T.c(v.dy,"role","button")
v.h(v.dy)
q=v.f=new V.p(1,0,v,T.E(v.dy))
v.r=new K.D(new D.v(q,Q.ax3()),q)
y=T.r(r,v.dy)
v.A(y,"tgl-container")
v.h(y)
q=T.r(r,y)
v.fr=q
T.c(q,u,"")
v.A(v.fr,"tgl-bar")
v.h(v.fr)
x=T.r(r,y)
v.A(x,"tgl-btn-container")
v.h(x)
q=T.r(r,x)
v.fx=q
v.A(q,"tgl-btn-underlay")
v.h(v.fx)
q=T.r(r,v.fx)
v.fy=q
T.c(q,u,"")
v.A(v.fy,"tgl-btn")
v.h(v.fy)
v.bq(v.fy,0)
q=v.dy
w=W.F;(q&&C.D).R(q,"blur",v.u(v.gKQ(),w,w))
q=v.dy;(q&&C.D).R(q,"focus",v.u(v.gNp(),w,w))
q=v.dy;(q&&C.D).R(q,"mouseenter",v.u(v.gO4(),w,w))
q=v.dy;(q&&C.D).R(q,"mouseleave",v.u(v.gO8(),w,w))
t.c=v.dy
v.ae()
q=J.af(s)
q.R(s,"click",v.u(t.gcs(),w,W.ax))
q.R(s,"keypress",v.u(t.gca(),w,W.a_))},
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
if(m!==v){T.c(p.dy,"aria-disabled",v)
p.Q=v}u=n.gfg()
if(u==null)u=""
m=p.ch
if(m!==u){T.c(p.dy,"aria-label",u)
p.ch=u}t=O.ad(n.y)
m=p.cx
if(m!==t){T.c(p.fr,o,t)
p.cx=t}s=n.e
m=p.cy
if(m!=s){T.a5(p.fx,"under-checked",s)
p.cy=s}r=n.z
m=p.db
if(m!==r){T.a5(p.fx,"under-focus",r)
p.db=r}q=O.ad(n.y)
m=p.dx
if(m!==q){T.c(p.fy,o,q)
p.dx=q}},
v:function(){this.f.G()},
KR:function(d){var y=this.b
y.z=!1
y.nH()},
Nq:function(d){var y=this.b
y.z=!0
y.nH()},
O5:function(d){var y=this.b
y.Q=!0
y.nH()},
O9:function(d){var y=this.b
y.Q=!1
y.nH()}}
Q.Vs.prototype={
p:function(){var y=this,x=document.createElement("div")
y.A(x,"tgl-lbl")
y.h(x)
x.appendChild(y.f.b)
y.E(x)},
q:function(){var y=this.b.r
if(y==null)y=""
this.f.W(y)}}
Q.Vt.prototype={
p:function(){var y=this,x=y.f=Q.ce(y,0),w=x.a
x=D.ca(x,null)
y.r=x
y.f.n(0,x,y.e.e)
y.E(w)
return new D.B(y,w,y.r,[D.j8])},
N:function(d,e,f){if(d===C.d&&0===e)return this.r
return f},
q:function(){var y=this.e.cx
this.f.i()
if(y===0)this.r.bk()},
v:function(){this.f.j()}}
var z=a.updateTypes([{func:1,ret:-1,args:[,]},{func:1,ret:-1,args:[W.ax]},{func:1,ret:-1,args:[W.a_]},{func:1,ret:-1,args:[P.u]},{func:1,ret:[S.m,-1],args:[A.az,P.C]},{func:1,ret:[S.m,D.j8]}])
D.FI.prototype={
$1:function(d){return this.a.$1(d)},
$S:48};(function installTearOffs(){var y=a._instance_1u,x=a._static_2,w=a._static_0
var v
y(v=D.j8.prototype,"gcs","e4",1)
y(v,"gca","iL",2)
y(v,"ghK","e6",3)
x(Q,"ax3","aHW",4)
w(Q,"ax4","aHX",5)
y(v=Q.uO.prototype,"gKQ","KR",0)
y(v,"gNp","Nq",0)
y(v,"gO4","O5",0)
y(v,"gO8","O9",0)})();(function inheritance(){var y=a.inherit,x=a.inheritMany
y(D.j8,P.k)
y(D.FI,H.aW)
x(S.m,[Q.uO,Q.Vs,Q.Vt])})();(function constants(){C.iw=new D.z("material-toggle",Q.ax4(),[D.j8])
C.or=H.x(D.j8)})();(function staticFields(){$.aC0=['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px;overflow:visible}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px;color:#009688}.tgl-btn-underlay._ngcontent-%ID%{width:40px;height:40px;border-radius:50%;margin:-10px}.tgl-btn-underlay.under-focus._ngcontent-%ID%{background-color:rgba(188,188,188,0.24)}.tgl-btn-underlay.under-focus.under-checked._ngcontent-%ID%{background-color:rgba(0,150,136,0.24)}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);margin:10px;background-color:#fafafa;opacity:1;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']
$.a6M=null
$.abf=!1
$.aAS=[$.aC0]})()}
$__dart_deferred_initializers__["lKqVHzEyOTSwYx+J1PS7lBgwL3M="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_5.part.js.map
