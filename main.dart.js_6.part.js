self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P,W,G,Y,R,K,V,E,M,Q={
cJ:function(d,e){var x,w=new Q.v5(E.S(d,e,1)),v=$.a8I
if(v==null)v=$.a8I=O.a0($.aEm,null)
w.b=v
x=document.createElement("material-toggle")
w.c=x
w.O(x,"themeable")
return w},
aLA:function(d,e){return new Q.Jx(N.P(),E.z(d,e))},
aLB:function(){return new Q.Jy(new G.R())},
oK:function(){if($.adm)return
$.adm=!0
$.T.w(0,C.mG,new D.l("material-toggle",Q.aB1(),y.k))
E.F()
V.h_()
K.dq()},
v5:function v5(d){var _=this
_.c=_.b=_.a=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
Jx:function Jx(d,e){this.b=d
this.a=e},
Jy:function Jy(d){var _=this
_.c=_.b=_.a=null
_.d=d}},D={
cH:function(d,e){return new D.jE(d,new P.b6(null,null,y.c))},
jE:function jE(d,e){var _=this
_.a=null
_.b=d
_.c=null
_.e=_.d=!1
_.f=e
_.r=null
_.y=1
_.Q=_.z=!1},
S_:function S_(d){this.a=d}},Z,O,A,T,L,N,U,X,B,S,F
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
E=c[10]
M=c[11]
Q=a.updateHolder(c[12],Q)
D=a.updateHolder(c[13],D)
Z=c[14]
O=c[15]
A=c[16]
T=c[17]
L=c[18]
N=c[19]
U=c[20]
X=c[21]
B=c[22]
S=c[23]
F=c[24]
D.jE.prototype={
gfv:function(){var x=this.r
return x},
o3:function(){if(this.Q)var x=3
else x=this.z?2:1
this.y=x},
lV:function(){var x,w=this
if(!w.d){w.e=!w.e
w.bj()
w.f.R(0,w.e)
x=w.a
if(x!=null)x.$0()}},
dR:function(d){this.lV()
d.preventDefault()
d.stopPropagation()},
iU:function(d){if(d.keyCode===13||Z.iS(d)){this.lV()
d.preventDefault()
d.stopPropagation()}},
bj:function(){var x=this.c
if(x==null)return
x.setAttribute("aria-pressed",H.B(this.e))},
f6:function(d,e){var x
this.e=e
this.bj()
x=this.b
if(x!=null)x.am()},
f2:function(d){var x=this.f
new P.e(x,H.m(x).i("e<1>")).D(new D.S_(d))},
i1:function(d){this.a=d},
ed:function(d){var x
this.d=d
x=this.b
if(x!=null)x.am()}}
Q.v5.prototype={
q:function(){var x,w,v,u=this,t="animated",s=u.a,r=u.a2(),q=document,p=T.u(q,r)
u.dx=p
u.C(p,"material-toggle")
T.c(u.dx,"role","button")
u.h(u.dx)
p=u.e=new V.r(1,0,u,T.L(u.dx))
u.f=new K.J(new D.x(p,Q.aB0()),p)
x=T.u(q,u.dx)
u.C(x,"tgl-container")
u.h(x)
p=T.u(q,x)
u.dy=p
T.c(p,t,"")
u.C(u.dy,"tgl-bar")
u.h(u.dy)
w=T.u(q,x)
u.C(w,"tgl-btn-container")
u.h(w)
p=T.u(q,w)
u.fr=p
u.C(p,"tgl-btn-underlay")
u.h(u.fr)
p=T.u(q,u.fr)
u.fx=p
T.c(p,t,"")
u.C(u.fx,"tgl-btn")
u.h(u.fx)
u.br(u.fx,0)
p=u.dx
v=y.l;(p&&C.w).T(p,"blur",u.v(u.gUY(),v,v))
p=u.dx;(p&&C.w).T(p,"focus",u.v(u.gV_(),v,v))
p=u.dx;(p&&C.w).T(p,"mouseenter",u.v(u.gV1(),v,v))
p=u.dx;(p&&C.w).T(p,"mouseleave",u.v(u.gV3(),v,v))
s.c=u.dx
p=J.aL(r)
p.T(r,"click",u.v(s.gcn(),v,y.e))
p.T(r,"keypress",u.v(s.gcd(),v,y.f))},
A:function(){var x,w,v,u,t,s,r,q,p,o=this,n="elevation",m=o.a,l=o.f,k=m.r
l.sU(k!=null&&k.length!==0)
o.e.J()
x=m.e
l=o.r
if(l!=x){T.ad(o.dx,"checked",x)
o.r=x}w=m.d
l=o.x
if(l!=w){T.ad(o.dx,"disabled",w)
o.x=w}v=m.d?"-1":"0"
l=o.y
if(l!==v){l=o.dx
T.Q(l,"tabindex",v)
o.y=v}u=m.d
l=o.z
if(l!=u){T.c(o.dx,"aria-disabled",O.b8(u))
o.z=u}t=m.gfv()
if(t==null)t=""
l=o.Q
if(l!==t){T.c(o.dx,"aria-label",t)
o.Q=t}s=m.y
l=o.ch
if(l!==s){T.c(o.dy,n,O.b8(s))
o.ch=s}r=m.e
l=o.cx
if(l!=r){T.ad(o.fr,"under-checked",r)
o.cx=r}q=m.z
l=o.cy
if(l!==q){T.ad(o.fr,"under-focus",q)
o.cy=q}p=m.y
l=o.db
if(l!==p){T.c(o.fx,n,O.b8(p))
o.db=p}},
G:function(){this.e.I()},
UZ:function(d){var x=this.a
x.z=!1
x.o3()},
V0:function(d){var x=this.a
x.z=!0
x.o3()},
V2:function(d){var x=this.a
x.Q=!0
x.o3()},
V4:function(d){var x=this.a
x.Q=!1
x.o3()}}
Q.Jx.prototype={
q:function(){var x=this,w=document.createElement("div")
x.C(w,"tgl-lbl")
x.h(w)
w.appendChild(x.b.b)
x.F(w)},
A:function(){var x=this.a.a.r
if(x==null)x=""
this.b.a5(x)}}
Q.Jy.prototype={
q:function(){var x=this,w=x.b=Q.cJ(x,0),v=w.c
x.a=D.cH(w,null)
x.F(v)},
P:function(d,e,f){if(d===C.c&&0===e)return this.a
return f},
A:function(){var x=this.d.e
this.b.j()
if(x===0)this.a.bj()}}
var z=a.updateTypes(["~(@)","~(V*)","~(b3*)","~(E*)","aj<~>*(k*,H*)","f<jE*>*()"])
D.S_.prototype={
$1:function(d){return this.a.$1(d)},
$S:71};(function installTearOffs(){var x=a._instance_1u,w=a._static_2,v=a._static_0
var u
x(u=D.jE.prototype,"gcn","dR",1)
x(u,"gcd","iU",2)
x(u,"ghX","ed",3)
w(Q,"aB0","aLA",4)
v(Q,"aB1","aLB",5)
x(u=Q.v5.prototype,"gUY","UZ",0)
x(u,"gV_","V0",0)
x(u,"gV1","V2",0)
x(u,"gV3","V4",0)})();(function inheritance(){var x=a.inherit
x(D.jE,P.y)
x(D.S_,H.bq)
x(Q.v5,E.bn)
x(Q.Jx,E.aj)
x(Q.Jy,G.f)})()
H.ak(b.typeUniverse,JSON.parse('{"al":"w","ax":"w","ap":"ae","am":"o","aB":"o","aD":"o","an":"G","ao":"G","at":"I","ay":"I","aq":"A","aA":"A","aG":"O","aF":"a3","aE":"a9","av":"U","aw":"ac","aC":"V","az":"ah","au":"af","as":"ai","ar":"a1","v5":{"k":[],"i":[]},"Jx":{"k":[],"i":[]},"Jy":{"f":["jE*"],"i":[],"f.T":"jE*"}}'))
0
var y={k:H.K("l<jE*>"),c:H.K("b6<E*>"),l:H.K("w*"),f:H.K("b3*"),e:H.K("V*")};(function constants(){C.mG=H.C("jE")})();(function staticFields(){$.aFr=['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px;overflow:visible}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px;color:#009688}.tgl-btn-underlay._ngcontent-%ID%{width:40px;height:40px;border-radius:50%;margin:-10px}.tgl-btn-underlay.under-focus._ngcontent-%ID%{background-color:rgba(188,188,188,0.24)}.tgl-btn-underlay.under-focus.under-checked._ngcontent-%ID%{background-color:rgba(0,150,136,0.24)}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);margin:10px;background-color:#fafafa;opacity:1;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']
$.a8I=null
$.adm=!1
$.aEm=[$.aFr]})()}
$__dart_deferred_initializers__["Q109QP6N1DaMMx69EY0s1paIgBU="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_6.part.js.map
