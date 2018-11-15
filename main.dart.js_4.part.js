self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,d,e,f,g,h,i,j,k,l,m,n,$){var C,H,J,P,W,G,Y,R,K,V,S,N,E,M,B,Q={
ca:function(o,p){var y,x
y=new Q.uT(P.e(P.c,null),o)
y.a=S.i(y,1,C.j,p)
x=document.createElement("material-toggle")
y.e=x
x.className="themeable"
x=$.a1u
if(x==null){x=$.D
x=x.Z(null,C.o,$.$get$ajb())
$.a1u=x}y.Y(x)
return y},
aGM:function(o,p){var y=new Q.W7(P.e(P.c,null),o)
y.a=S.i(y,3,C.b,p)
y.d=$.a1u
return y},
aGN:function(o,p){var y=new Q.W8(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p)
return y},
m3:function(){if($.abH)return
$.abH=!0
$.$get$G().v(0,C.oj,C.i1)
E.y()
V.fB()
K.cL()},
uT:function uT(o,p){var _=this
_.a=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
W7:function W7(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
W8:function W8(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null}},D={
c5:function(o,p){return new D.h_(o,!1,!1,new P.a0(null,null,0,[P.q]),1,!1,!1)},
h_:function h_(o,p,q,r,s,t,u){var _=this
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
GD:function GD(o){this.a=o}},L,Z,A,U,T,O,X,F
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
D.h_.prototype={
sc_:function(o,p){this.e=p
this.bL()},
gc_:function(o){return this.e},
sI6:function(o){this.z=o
this.Gc()},
sIr:function(o){this.Q=o
this.Gc()},
Gc:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
n7:function(){if(!this.d){this.e=!this.e
this.bL()
this.f.R(0,this.e)
var y=this.a
if(!(y==null))y.$0()}},
fQ:function(o){this.n7()
o.preventDefault()
o.stopPropagation()},
jR:function(o){if(o.keyCode===13||Z.jm(o)){this.n7()
o.preventDefault()
o.stopPropagation()}},
bL:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.w(this.e))},
h_:function(o,p){this.e=p
this.bL()
this.b.a.aE()},
fW:function(o){var y=this.f
new P.m(y,[H.h(y,0)]).B(new D.GD(o))},
j3:function(o){this.a=o},
f0:function(o){this.d=o
this.b.a.aE()},
gbr:function(o){return this.d},
gda:function(o){return this.r},
sa7w:function(o){return this.c=o},
sbr:function(o,p){return this.d=p},
sda:function(o,p){return this.r=p}}
Q.uT.prototype={
p:function(){var y,x,w,v,u,t,s,r
y=this.f
x=this.e
w=this.a0(x)
v=document
u=S.p(v,w)
this.r=u
u.className="material-toggle"
u.setAttribute("role","button")
this.h(this.r)
u=$.$get$J().cloneNode(!1)
this.r.appendChild(u)
u=new V.o(1,0,this,u)
this.x=u
this.y=new K.B(new D.r(u,Q.azl()),u,!1)
t=S.p(v,this.r)
t.className="tgl-container"
this.h(t)
u=S.p(v,t)
this.z=u
u.setAttribute("animated","")
u=this.z
u.className="tgl-bar"
this.h(u)
s=S.p(v,t)
s.className="tgl-btn-container"
this.h(s)
u=S.p(v,s)
this.Q=u
u.setAttribute("animated","")
u=this.Q
u.className="tgl-btn"
this.h(u)
this.bX(this.Q,0)
u=this.r
r=W.E;(u&&C.u).a4(u,"blur",this.w(this.gO8(),r,r))
u=this.r;(u&&C.u).a4(u,"focus",this.w(this.gQA(),r,r))
u=this.r;(u&&C.u).a4(u,"mouseenter",this.w(this.gRn(),r,r))
u=this.r;(u&&C.u).a4(u,"mouseleave",this.w(this.gRr(),r,r))
this.f.sa7w(this.r)
this.L(C.a,null)
u=J.Z(x)
u.a4(x,"click",this.w(y.gcP(),r,W.am))
u.a4(x,"keypress",this.w(y.gcK(),r,W.a5))},
q:function(){var y,x,w,v,u,t,s,r,q,p
y=this.f
x=this.y
w=y.r
x.sW(w!=null&&w.length!==0)
this.x.H()
v=y.e
x=this.ch
if(x!=v){this.at(this.r,"checked",v)
this.ch=v}u=y.d
x=this.cx
if(x!=u){this.at(this.r,"disabled",u)
this.cx=u}t=y.d?"-1":"0"
x=this.cy
if(x!==t){x=this.r
this.a5(x,"tabindex",t)
this.cy=t}s=Q.H(y.d)
x=this.db
if(x!==s){this.a5(this.r,"aria-disabled",J.bI(s))
this.db=s}x=y.x
r=x==null?y.r:x
if(r==null)r=""
x=this.dx
if(x!==r){this.a5(this.r,"aria-label",r)
this.dx=r}q=Q.H(y.y)
x=this.dy
if(x!==q){this.a5(this.z,"elevation",J.bI(q))
this.dy=q}p=Q.H(y.y)
x=this.fr
if(x!==p){this.a5(this.Q,"elevation",J.bI(p))
this.fr=p}},
u:function(){var y=this.x
if(!(y==null))y.G()},
O9:function(o){this.f.sI6(!1)},
QB:function(o){this.f.sI6(!0)},
Ro:function(o){this.f.sIr(!0)},
Rs:function(o){this.f.sIr(!1)},
$asb:function(){return[D.h_]}}
Q.W7.prototype={
p:function(){var y,x,w
y=document
x=y.createElement("div")
x.className="tgl-lbl"
this.h(x)
w=y.createTextNode("")
this.r=w
x.appendChild(w)
this.E(x)},
q:function(){var y,x
y=this.f.r
if(y==null)y=""
x=this.x
if(x!==y){this.r.textContent=y
this.x=y}},
$asb:function(){return[D.h_]}}
Q.W8.prototype={
p:function(){var y=Q.ca(this,0)
this.r=y
this.e=y.e
y=D.c5(y.a.b,null)
this.x=y
this.r.k(0,y,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[D.h_])},
N:function(o,p,q){if(o===C.c&&0===p)return this.x
return q},
q:function(){var y=this.a.cy
this.r.j()
if(y===0)this.x.bL()},
u:function(){var y=this.r
if(!(y==null))y.i()},
$asb:function(){return[D.h_]}}
var z=j([{func:1,ret:-1,args:[,]},{func:1,ret:[S.b,D.h_],args:[[S.b,,],P.k]},{func:1,ret:-1,args:[W.am]},{func:1,ret:-1,args:[W.a5]},{func:1,ret:-1,args:[P.q]}])
D.GD.prototype={
$1:function(o){return this.a.$1(o)},
"call*":"$1",
$R:1};(function installTearOffs(){var y
g(y=D.h_.prototype,"gcP",0,0,0,null,["$1"],["fQ"],2,0)
g(y,"gcK",0,0,0,null,["$1"],["jR"],3,0)
g(y,"gj2",0,0,1,null,["$1"],["f0"],4,0)
g(Q,"azl",1,0,0,null,["$2"],["aGM"],1,0)
g(Q,"azm",1,0,0,null,["$2"],["aGN"],1,0)
g(y=Q.uT.prototype,"gO8",0,0,0,null,["$1"],["O9"],0,0)
g(y,"gQA",0,0,0,null,["$1"],["QB"],0,0)
g(y,"gRn",0,0,0,null,["$1"],["Ro"],0,0)
g(y,"gRr",0,0,0,null,["$1"],["Rs"],0,0)})();(function inheritance(){var y=a,x=b
y(D.h_,P.t)
y(D.GD,H.aK)
x(S.b,[Q.uT,Q.W7,Q.W8])})();(function constants(){C.i1=new D.x("material-toggle",Q.azm(),[D.h_])
C.oj=H.v(D.h_)})();(function staticFields(){$.a1u=null
$.abH=!1})();(function lazyInitializers(){d($,"akb","$get$akb",function(){return['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked:not(.disabled)._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);background-color:#fafafa;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']})
d($,"ajb","$get$ajb",function(){return[$.$get$akb()]})})()}
$__dart_deferred_initializers__["53i/+LREyXAKSXyP4Roh2uG9hrs="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_4.part.js.map
