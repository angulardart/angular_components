self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,d,e,f,g,h,i,j,k,l,m,$){var C,H,J,P,W,G,Y,R,K,V,S,N,E,M,B,Q={
c7:function(n,o){var y,x
y=new Q.uO(P.e(P.c,null),n)
y.a=S.h(y,1,C.j,o)
x=document.createElement("material-toggle")
y.e=x
x.className="themeable"
x=$.a0R
if(x==null){x=$.D
x=x.Y(null,C.o,$.$get$aiw())
$.a0R=x}y.X(x)
return y},
aGx:function(n,o){var y=new Q.Vz(P.e(P.c,null),n)
y.a=S.h(y,3,C.b,o)
y.d=$.a0R
return y},
aGy:function(n,o){var y=new Q.VA(P.e(P.c,null),n)
y.a=S.h(y,3,C.k,o)
return y},
m_:function(){if($.ab2)return
$.ab2=!0
$.$get$G().u(0,C.o9,C.hV)
E.y()
V.fB()
K.cK()},
uO:function uO(n,o){var _=this
_.a=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=n
_.c=o
_.f=_.e=_.d=null},
Vz:function Vz(n,o){var _=this
_.a=_.x=_.r=null
_.b=n
_.c=o
_.f=_.e=_.d=null},
VA:function VA(n,o){var _=this
_.a=_.x=_.r=null
_.b=n
_.c=o
_.f=_.e=_.d=null}},D={
c1:function(n,o){return new D.fZ(n,!1,!1,new P.a0(null,null,0,[P.q]),1,!1,!1)},
fZ:function fZ(n,o,p,q,r,s,t){var _=this
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
Gq:function Gq(n){this.a=n}},L,Z,A,U,T,O,X,F
g([Q,D])
C=m[0]
H=m[1]
J=m[2]
P=m[3]
W=m[4]
G=m[5]
Y=m[6]
R=m[7]
K=m[8]
V=m[9]
S=m[10]
N=m[11]
E=m[12]
M=m[13]
B=m[14]
Q=h(m[15],Q)
D=h(m[16],D)
L=m[17]
Z=m[18]
A=m[19]
U=m[20]
T=m[21]
O=m[22]
X=m[23]
F=m[24]
D.fZ.prototype={
sbY:function(n,o){this.e=o
this.bK()},
gbY:function(n){return this.e},
sHZ:function(n){this.z=n
this.G3()},
sIj:function(n){this.Q=n
this.G3()},
G3:function(){if(this.Q)var y=3
else y=this.z?2:1
this.y=y},
n4:function(){if(!this.d){this.e=!this.e
this.bK()
this.f.P(0,this.e)
var y=this.a
if(!(y==null))y.$0()}},
fP:function(n){this.n4()
n.preventDefault()
n.stopPropagation()},
jN:function(n){if(n.keyCode===13||Z.jj(n)){this.n4()
n.preventDefault()
n.stopPropagation()}},
bK:function(){var y=this.c
if(y==null)return
y.setAttribute("aria-pressed",H.w(this.e))},
fZ:function(n,o){this.e=o
this.bK()
this.b.a.aF()},
fV:function(n){var y=this.f
new P.m(y,[H.j(y,0)]).B(new D.Gq(n))},
j0:function(n){this.a=n},
f0:function(n){this.d=n
this.b.a.aF()},
gbp:function(n){return this.d},
gda:function(n){return this.r},
sa7c:function(n){return this.c=n},
sbp:function(n,o){return this.d=o},
sda:function(n,o){return this.r=o}}
Q.uO.prototype={
p:function(){var y,x,w,v,u,t,s,r
y=this.f
x=this.e
w=this.Z(x)
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
this.y=new K.B(new D.r(u,Q.ayQ()),u,!1)
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
this.bW(this.Q,0)
u=this.r
r=W.E;(u&&C.u).a4(u,"blur",this.w(this.gO_(),r,r))
u=this.r;(u&&C.u).a4(u,"focus",this.w(this.gQr(),r,r))
u=this.r;(u&&C.u).a4(u,"mouseenter",this.w(this.gRe(),r,r))
u=this.r;(u&&C.u).a4(u,"mouseleave",this.w(this.gRi(),r,r))
this.f.sa7c(this.r)
this.L(C.a,null)
u=J.Z(x)
u.a4(x,"click",this.w(y.gcO(),r,W.am))
u.a4(x,"keypress",this.w(y.gcJ(),r,W.a4))},
q:function(){var y,x,w,v,u,t,s,r,q,p
y=this.f
x=this.y
w=y.r
x.sV(w!=null&&w.length!==0)
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
this.cy=t}s=Q.I(y.d)
x=this.db
if(x!==s){this.a5(this.r,"aria-disabled",J.bH(s))
this.db=s}x=y.x
r=x==null?y.r:x
if(r==null)r=""
x=this.dx
if(x!==r){this.a5(this.r,"aria-label",r)
this.dx=r}q=Q.I(y.y)
x=this.dy
if(x!==q){this.a5(this.z,"elevation",J.bH(q))
this.dy=q}p=Q.I(y.y)
x=this.fr
if(x!==p){this.a5(this.Q,"elevation",J.bH(p))
this.fr=p}},
v:function(){var y=this.x
if(!(y==null))y.G()},
O0:function(n){this.f.sHZ(!1)},
Qs:function(n){this.f.sHZ(!0)},
Rf:function(n){this.f.sIj(!0)},
Rj:function(n){this.f.sIj(!1)},
$asb:function(){return[D.fZ]}}
Q.Vz.prototype={
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
$asb:function(){return[D.fZ]}}
Q.VA.prototype={
p:function(){var y=Q.c7(this,0)
this.r=y
this.e=y.e
y=D.c1(y.a.b,null)
this.x=y
this.r.k(0,y,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[D.fZ])},
N:function(n,o,p){if(n===C.c&&0===o)return this.x
return p},
q:function(){var y=this.a.cy
this.r.j()
if(y===0)this.x.bK()},
v:function(){var y=this.r
if(!(y==null))y.i()},
$asb:function(){return[D.fZ]}}
var z=i([{func:1,ret:-1,args:[,]},{func:1,ret:[S.b,D.fZ],args:[[S.b,,],P.k]},{func:1,ret:-1,args:[W.am]},{func:1,ret:-1,args:[W.a4]},{func:1,ret:-1,args:[P.q]}])
D.Gq.prototype={
$1:function(n){return this.a.$1(n)},
"call*":"$1",
$R:1};(function installTearOffs(){var y
f(y=D.fZ.prototype,"gcO",0,0,0,null,["$1"],["fP"],2,0)
f(y,"gcJ",0,0,0,null,["$1"],["jN"],3,0)
f(y,"gj_",0,0,1,null,["$1"],["f0"],4,0)
f(Q,"ayQ",1,0,0,null,["$2"],["aGx"],1,0)
f(Q,"ayR",1,0,0,null,["$2"],["aGy"],1,0)
f(y=Q.uO.prototype,"gO_",0,0,0,null,["$1"],["O0"],0,0)
f(y,"gQr",0,0,0,null,["$1"],["Qs"],0,0)
f(y,"gRe",0,0,0,null,["$1"],["Rf"],0,0)
f(y,"gRi",0,0,0,null,["$1"],["Rj"],0,0)})();(function inheritance(){a(D.fZ,P.u)
a(D.Gq,H.aK)
var y=S.b
a(Q.uO,y)
a(Q.Vz,y)
a(Q.VA,y)})();(function constants(){C.hV=new D.x("material-toggle",Q.ayR(),[D.fZ])
C.o9=H.v(D.fZ)})();(function staticFields(){$.a0R=null
$.ab2=!1})();(function lazyInitializers(){c($,"ajv","$get$ajv",function(){return['._nghost-%ID%{display:inline-block;text-align:initial}.material-toggle._ngcontent-%ID%{display:inline-flex;align-items:center;justify-content:flex-end;cursor:pointer;outline:none;width:100%}.material-toggle.disabled._ngcontent-%ID%{pointer-events:none}.tgl-container._ngcontent-%ID%{display:inline-block;min-width:36px;position:relative;vertical-align:middle;width:36px}.tgl-bar._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);transition:opacity 130ms cubic-bezier(0.4,0,0.2,1);background-color:rgba(0,0,0,0.26);border-radius:8px;height:14px;margin:2px 0;width:100%}.tgl-bar[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-bar[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-bar[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-bar[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-bar[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-bar[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:#009688;opacity:0.5}.tgl-btn-container._ngcontent-%ID%{display:inline-flex;justify-content:flex-end;transition:width 130ms cubic-bezier(0.4,0,0.2,1);margin-top:-2px;position:absolute;top:0;width:20px}.material-toggle.checked._ngcontent-%ID% .tgl-btn-container._ngcontent-%ID%{width:36px}.tgl-btn._ngcontent-%ID%{transition:background-color 130ms cubic-bezier(0.4,0,0.2,1);background-color:#fafafa;border-radius:50%;height:20px;position:relative;width:20px}.tgl-btn[animated]._ngcontent-%ID%{transition:box-shadow 0.28s cubic-bezier(0.4,0,0.2,1)}.tgl-btn[elevation="1"]._ngcontent-%ID%{box-shadow:0 2px 2px 0 rgba(0,0,0,0.14),0 3px 1px -2px rgba(0,0,0,0.12),0 1px 5px 0 rgba(0,0,0,0.2)}.tgl-btn[elevation="2"]._ngcontent-%ID%{box-shadow:0 4px 5px 0 rgba(0,0,0,0.14),0 1px 10px 0 rgba(0,0,0,0.12),0 2px 4px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="3"]._ngcontent-%ID%{box-shadow:0 6px 10px 0 rgba(0,0,0,0.14),0 1px 18px 0 rgba(0,0,0,0.12),0 3px 5px -1px rgba(0,0,0,0.2)}.tgl-btn[elevation="4"]._ngcontent-%ID%{box-shadow:0 8px 10px 1px rgba(0,0,0,0.14),0 3px 14px 2px rgba(0,0,0,0.12),0 5px 5px -3px rgba(0,0,0,0.2)}.tgl-btn[elevation="5"]._ngcontent-%ID%{box-shadow:0 16px 24px 2px rgba(0,0,0,0.14),0 6px 30px 5px rgba(0,0,0,0.12),0 8px 10px -5px rgba(0,0,0,0.2)}.tgl-btn[elevation="6"]._ngcontent-%ID%{box-shadow:0 24px 38px 3px rgba(0,0,0,0.14),0 9px 46px 8px rgba(0,0,0,0.12),0 11px 15px -7px rgba(0,0,0,0.2)}.material-toggle.checked._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#009688}.tgl-lbl._ngcontent-%ID%{flex-grow:1;display:inline-block;padding:2px 8px 2px 0;position:relative;vertical-align:middle;white-space:normal}.material-toggle.disabled._ngcontent-%ID% .tgl-lbl._ngcontent-%ID%{opacity:0.54}.material-toggle.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-btn._ngcontent-%ID%{background-color:#bdbdbd}.material-toggle.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%,.material-toggle.checked.disabled._ngcontent-%ID% .tgl-bar._ngcontent-%ID%{background-color:rgba(0,0,0,0.12)}']})
c($,"aiw","$get$aiw",function(){return[$.$get$ajv()]})})()}
$__dart_deferred_initializers__["O230KnCFZ2sZePQn7YNeQH260Zk="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_4.part.js.map
