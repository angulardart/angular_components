self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P,W,G,Y,R,K,V,S,E,M,Q={
cp:function(d,e){var y,x=new Q.ve(E.L(d,e,1)),w=$.a7C
if(w==null)w=$.a7C=O.T($.aBU,null)
x.b=w
y=document.createElement("material-toggle")
x.c=y
x.N(y,"themeable")
return x},
aJ6:function(d,e){return new Q.W9(N.I(),E.y(d,e,D.hG))},
aJ7:function(d){return new Q.Wa(d,new G.K())},
n2:function(){if($.ac9)return
$.ac9=!0
$.N.D(0,C.ou,C.iw)
E.C()
V.ft()
K.d9()},
ve:function ve(d){var _=this
_.c=_.b=_.a=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
W9:function W9(d,e){this.b=d
this.a=e},
Wa:function Wa(d,e){var _=this
_.b=_.a=null
_.c=d
_.d=e}},D={
cm:function(d,e){return new D.hG(d,new P.ad(null,null,[P.v]))},
hG:function hG(d,e){var _=this
_.a=null
_.b=d
_.c=null
_.e=_.d=!1
_.f=e
_.r=null
_.y=1
_.Q=_.z=!1},
Gg:function Gg(d){this.a=d}},L,Z,O,B,A,U,T,N,X,F
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
D.hG.prototype={
gfq:function(){var y=this.r
return y},
o5:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
lW:function(){var y,x=this
if(!x.d){x.e=!x.e
x.bn()
x.f.P(0,x.e)
y=x.a
if(y!=null)y.$0()}},
dV:function(d){this.lW()
d.preventDefault()
d.stopPropagation()},
iZ:function(d){if(d.keyCode===13||Z.i3(d)){this.lW()
d.preventDefault()
d.stopPropagation()}},
bn:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.z(this.e))},
f5:function(d,e){var y
this.e=e
this.bn()
y=this.b
if(y!=null)y.an()},
f1:function(d){var y=this.f
new P.o(y,[H.e(y,0)]).B(new D.Gg(d))},
i4:function(d){this.a=d},
ed:function(d){var y
this.d=d
y=this.b
if(y!=null)y.an()}}
Q.ve.prototype={
p:function(){var y,x,w,v=this,u="animated",t=v.a,s=v.a2(),r=document,q=T.u(r,s)
v.dx=q
v.A(q,"material-toggle")
T.c(v.dx,"role","button")
v.h(v.dx)
q=v.e=new V.q(1,0,v,T.G(v.dx))
v.f=new K.F(new D.x(q,Q.ay4()),q)
y=T.u(r,v.dx)
v.A(y,"tgl-container")
v.h(y)
q=T.u(r,y)
v.dy=q
T.c(q,u,"")
v.A(v.dy,"tgl-bar")
v.h(v.dy)
x=T.u(r,y)
v.A(x,"tgl-btn-container")
v.h(x)
q=T.u(r,x)
v.fr=q
v.A(q,"tgl-btn-underlay")
v.h(v.fr)
q=T.u(r,v.fr)
v.fx=q
T.c(q,u,"")
v.A(v.fx,"tgl-btn")
v.h(v.fx)
v.bv(v.fx,0)
q=v.dx
w=W.H;(q&&C.y).S(q,"blur",v.u(v.gUO(),w,w))
q=v.dx;(q&&C.y).S(q,"focus",v.u(v.gUQ(),w,w))
q=v.dx;(q&&C.y).S(q,"mouseenter",v.u(v.gUS(),w,w))
q=v.dx;(q&&C.y).S(q,"mouseleave",v.u(v.gUU(),w,w))
t.c=v.dx
q=J.al(s)
q.S(s,"click",v.u(t.gcs(),w,W.aF))
q.S(s,"keypress",v.u(t.gci(),w,W.a4))},
v:function(){var y,x,w,v,u,t,s,r,q,p=this,o="elevation",n=p.a,m=p.f,l=n.r
m.sU(l!=null&&l.length!==0)
p.e.I()
y=n.e
m=p.r
if(m!=y){T.a8(p.dx,"checked",y)
p.r=y}x=n.d
m=p.x
if(m!=x){T.a8(p.dx,"disabled",x)
p.x=x}w=n.d?"-1":"0"
m=p.y
if(m!==w){m=p.dx
T.J(m,"tabindex",w)
p.y=w}v=O.ai(n.d)
m=p.z
if(m!==v){T.c(p.dx,"aria-disabled",v)
p.z=v}u=n.gfq()
if(u==null)u=""
m=p.Q
if(m!==u){T.c(p.dx,"aria-label",u)
p.Q=u}t=O.ai(n.y)
m=p.ch
if(m!==t){T.c(p.dy,o,t)
p.ch=t}s=n.e
m=p.cx
if(m!=s){T.a8(p.fr,"under-checked",s)
p.cx=s}r=n.z
m=p.cy
if(m!==r){T.a8(p.fr,"under-focus",r)
p.cy=r}q=O.ai(n.y)
m=p.db
if(m!==q){T.c(p.fx,o,q)
p.db=q}},
F:function(){this.e.H()},
UP:function(d){var y=this.a
y.z=!1
y.o5()},
UR:function(d){var y=this.a
y.z=!0
y.o5()},
UT:function(d){var y=this.a
y.Q=!0
y.o5()},
UV:function(d){var y=this.a
y.Q=!1
y.o5()}}
Q.W9.prototype={
p:function(){var y=this,x=document.createElement("div")
y.A(x,"tgl-lbl")
y.h(x)
x.appendChild(y.b.b)
y.E(x)},
v:function(){var y=this.a.a.r
if(y==null)y=""
this.b.X(y)},
$ap:function(){return[D.hG]}}
Q.Wa.prototype={
p:function(){var y=this,x=y.b=Q.cp(y,0),w=x.c
y.a=D.cm(x,null)
y.E(w)},
O:function(d,e,f){if(d===C.c&&0===e)return this.a
return f},
v:function(){var y=this.d.e
this.b.i()
if(y===0)this.a.bn()},
$ak:function(){return[D.hG]}}
var z=a.updateTypes([{func:1,ret:-1,args:[,]},{func:1,ret:-1,args:[W.aF]},{func:1,ret:-1,args:[W.a4]},{func:1,ret:-1,args:[P.v]},{func:1,ret:[E.p,-1],args:[A.aB,P.E]},{func:1,ret:[G.k,D.hG],args:[M.t]}])
D.Gg.prototype={
$1:function(d){return this.a.$1(d)},
$S:58};(function installTearOffs(){var y=a._instance_1u,x=a._static_2,w=a._static_1
var v
y(v=D.hG.prototype,"gcs","dV",1)
y(v,"gci","iZ",2)
y(v,"ghY","ed",3)
x(Q,"ay4","aJ6",4)
w(Q,"ay5","aJ7",5)
y(v=Q.ve.prototype,"gUO","UP",0)
y(v,"gUQ","UR",0)
y(v,"gUS","UT",0)
y(v,"gUU","UV",0)})();(function inheritance(){var y=a.inherit
y(D.hG,P.l)
y(D.Gg,H.b8)
y(Q.ve,E.b5)
y(Q.W9,E.p)
y(Q.Wa,G.k)})();(function constants(){C.iw=new D.B("material-toggle",Q.ay5(),[D.hG])
C.ou=H.A(D.hG)})();(function staticFields(){$.aCZ=['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px;overflow:visible}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px;color:#009688}.tgl-btn-underlay._ngcontent-%ID%{width:40px;height:40px;border-radius:50%;margin:-10px}.tgl-btn-underlay.under-focus._ngcontent-%ID%{background-color:rgba(188,188,188,0.24)}.tgl-btn-underlay.under-focus.under-checked._ngcontent-%ID%{background-color:rgba(0,150,136,0.24)}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);margin:10px;background-color:#fafafa;opacity:1;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']
$.a7C=null
$.ac9=!1
$.aBU=[$.aCZ]})()}
$__dart_deferred_initializers__["O+9WQNXYc1Ut2mXOUYULeqJ7CKE="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_5.part.js.map
