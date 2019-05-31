self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={Qe:function Qe(d,e){this.a=d
this.$ti=e},
a7Z:function(d,e,f,g){var y,x,w,v,u,t,s,r=null,q=e.length
if(q!==0){w=0
while(!0){if(!(w<q)){y=""
x=0
break}if(C.f.bD(e,w)===64){y=C.f.b7(e,0,w)
x=w+1
break}++w}if(x<q&&C.f.bD(e,x)===91){for(v=x;v<q;++v)if(C.f.bD(e,v)===93)break
if(v===q)throw H.n(P.bv("Invalid IPv6 host entry.",e,x))
P.a0N(e,x+1,v);++v
if(v!==q&&C.f.bD(e,v)!==58)throw H.n(P.bv("Invalid end of authority",e,v))}else v=x
while(!0){if(!(v<q)){u=r
break}if(C.f.bD(e,v)===58){t=C.f.co(e,v+1)
u=t.length!==0?P.e3(t,r,r):r
break}++v}s=C.f.b7(e,x,v)}else{u=r
s=u
y=""}return P.amu(s,r,H.a(f.split("/"),[P.j]),u,g,d,y)}},W,G={
lj:function(d,e){var y,x=new G.Nw(d,S.h(1,C.i,e)),w=$.a7A
if(w==null)w=$.a7A=O.O($.aBr,null)
x.c=w
y=document.createElement("simple-html")
x.a=y
return x},
aJe:function(){return new G.Xk(null,S.h(3,C.j,null))},
a7y:function(d,e){var y,x=new G.Nv(d,S.h(1,C.i,e)),w=$.a7z
if(w==null)w=$.a7z=O.O($.aBq,null)
x.c=w
y=document.createElement("simple-html-block")
x.a=y
return x},
aJd:function(){return new G.Xj(null,S.h(3,C.j,null))},
agN:function(){if($.a8A)return
$.a8A=!0
$.H.C(0,C.oU,C.iB)
$.H.C(0,C.oT,C.j_)
E.A()
V.d3()},
Nw:function Nw(d,e){var _=this
_.c=_.b=_.a=null
_.d=d
_.e=e},
Xk:function Xk(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e},
Nv:function Nv(d,e){var _=this
_.c=_.b=_.a=null
_.d=d
_.e=e},
Xj:function Xj(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e},
h5:function h5(d){this.a=d}},Y={IS:function IS(){}},R={jy:function jy(){this.a=0}},K,V,S={lf:function lf(){}},E={
alK:function(){return C.eh},
aJc:function(){return new E.Xi(null,S.h(3,C.j,null))},
aqw:function(){if($.a8y)return
$.a8y=!0
$.H.C(0,C.oS,C.eh)
E.A()
K.cu()
D.cg()
A.arR()
F.asN()},
Nu:function Nu(d,e){var _=this
_.c=_.b=_.a=_.r1=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Xi:function Xi(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e}},M,Q,D,L,Z,O,B,A={
aJg:function(){return new A.Xm(null,S.h(3,C.j,null))},
arR:function(){if($.abL)return
$.abL=!0
$.H.C(0,C.oV,C.e9)
E.A()
G.agN()},
Ny:function Ny(d,e){var _=this
_.c=_.b=_.a=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Xm:function Xm(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e}},U,T,N,X,F={
le:function(d,e,f,g){var y=f==null?$.a2U():f
y=F.a8k(y,E.ee(g,!1))
return new F.ld(e,d,new P.y(null,null,[W.a6]),new R.J(!1),new F.ww(y))},
a4n:function(d,e,f,g){var y,x=f==null?$.a2U():f
x=F.a8k(x,E.ee(g,!1))
y=[P.j]
x.fU("p",H.a(["class"],y))
x.fU("ul",H.a(["class"],y))
x.fU("li",H.a(["class"],y))
return new F.lc(e,d,new P.y(null,null,[W.a6]),new R.J(!1),new F.ww(x))},
Qf:function(d,e){return new F.wW(!1,null,null,"Unsafe URI "+H.w(d)+" because "+e)},
Pb:function(d,e){return new F.vD(!1,null,null,"Element "+H.w(d)+" was malformed: "+e)},
a8n:function(d){var y,x,w=null
try{w=P.a0M(d)}catch(y){H.aA(y)
x=F.Qf(d,"Could not parse")
throw H.n(x)}return P.a4v().oE(w)},
amr:function(d){var y=new F.PI(P.lX(d,P.ew))
y.IT(d)
return y},
a8k:function(d,e){var y=e?new F.OA():F.amr(d),x=new W.pF(H.a([],[W.f5])),w=[P.j]
x.E2("a",H.a(["class","href","rel","target","title"],w),y)
x.fU("b",H.a(["class"],w))
x.fU("br",H.a(["class"],w))
x.fU("em",H.a(["class"],w))
x.fU("i",H.a(["class"],w))
x.fU("span",H.a(["class"],w))
x.fU("strong",H.a(["class"],w))
return x},
ld:function ld(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
lc:function lc(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
PM:function PM(){},
PP:function PP(d,e){this.a=d
this.b=e},
PO:function PO(d){this.a=d},
PN:function PN(d){this.a=d},
wW:function wW(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
vD:function vD(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
ww:function ww(d){this.a=d},
PI:function PI(d){this.a=d},
PK:function PK(){},
PJ:function PJ(d){this.a=d},
OA:function OA(){},
aJf:function(){return new F.Xl(null,S.h(3,C.j,null))},
asN:function(){if($.a8z)return
$.a8z=!0
$.H.C(0,C.pu,C.ev)
E.A()
G.agN()},
Nx:function Nx(d,e){var _=this
_.c=_.b=_.a=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Xl:function Xl(d,e){var _=this
_.c=_.b=_.a=_.x=_.r=_.f=null
_.d=d
_.e=e}}
a.setFunctionNamesIfNecessary([P,G,Y,R,S,E,A,F])
C=c[0]
H=c[1]
J=c[2]
P=a.updateHolder(c[3],P)
W=c[4]
G=a.updateHolder(c[5],G)
Y=a.updateHolder(c[6],Y)
R=a.updateHolder(c[7],R)
K=c[8]
V=c[9]
S=a.updateHolder(c[10],S)
E=a.updateHolder(c[11],E)
M=c[12]
Q=c[13]
D=c[14]
L=c[15]
Z=c[16]
O=c[17]
B=c[18]
A=a.updateHolder(c[19],A)
U=c[20]
T=c[21]
N=c[22]
X=c[23]
F=a.updateHolder(c[24],F)
P.Qe.prototype={
aO:function(d,e){return J.a02(this.a,e)},
gbf:function(d){return J.bM(J.a06(this.a))},
gK:function(d){return J.bA(this.a)},
P:function(d,e){throw H.n(P.ac("Cannot change unmodifiable set"))},
bn:function(d,e){throw H.n(P.ac("Cannot change unmodifiable set"))}}
F.ld.prototype={
gGJ:function(d){var y=this.f,x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.nW(y,x)
y=y.gdz(y)}return y}}
F.lc.prototype={
gGJ:function(d){var y=this.f,x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.nW(y,x)
y=y.gdz(y)}return y}}
F.PM.prototype={
sfV:function(d){this.a.cL(new F.PP(this,d))}}
F.wW.prototype={}
F.vD.prototype={}
F.ww.prototype={
ff:function(d){if(!this.a.ff(d))throw H.n(F.Pb(d,"prohibited element"))
return!0},
f1:function(d,e,f){var y
if(d.tagName.toLowerCase()==="a"&&e==="target"){if(!d.hasAttribute("rel"))throw H.n(F.Pb(d,"did not set rel attribute"))
y=d.getAttribute("rel")
if(!C.e.aO(H.a(y.split(" "),[P.j]),"noopener"))throw H.n(F.Pb(d,"did not set link type noopener (only "+y+")"))}if(!this.a.f1(d,e,f))throw H.n(F.Pb(d,"prohibited attribute "+e+" with value "+H.w(f)))
return!0},
$if5:1}
F.PI.prototype={
IT:function(d){C.e.aY(this.a,new F.PK())},
kO:function(d){var y,x,w,v=F.a8n(d),u=null
try{u=J.ajx(v)}catch(y){H.aA(y)
x=F.Qf(d,"Resolved URI "+H.w(v)+" had no origin")
throw H.n(x)}x=u
w=P.a4v()
if(!J.a1(x,w.glo(w))&&!this.Tl(v))throw H.n(F.Qf(d,"Different origin and non-whitelisted URL"))
return!0},
Tl:function(d){return C.e.ec(this.a,new F.PJ(d))}}
F.OA.prototype={
kO:function(d){var y=F.a8n(d)
if(!J.a02(C.mj.a,y.ghk()))throw H.n(F.Qf(d,"URI scheme "+H.w(y.ghk())+" not allowed"))
return!0}}
G.Nw.prototype={
p:function(){var y=this.a0()
this.l(T.cY(document,y))
this.ae()}}
G.Xk.prototype={
p:function(){var y,x,w=this,v=G.lj(w,0)
w.f=v
y=v.a
v=w.e
x=v.z
x=F.le(w.m(C.b,x),y,w.k(C.aK,x),null)
w.r=x
w.f.n(0,x,v.e)
w.E(y)
return new D.B(w,y,w.r,[F.ld])},
q:function(){this.f.i()},
v:function(){this.f.j()
this.r.d.F()}}
G.Nv.prototype={
p:function(){var y=this.a0()
this.h(T.r(document,y))
this.ae()}}
G.Xj.prototype={
p:function(){var y,x,w=this,v=G.a7y(w,0)
w.f=v
y=v.a
v=w.e
x=v.z
x=F.a4n(w.m(C.b,x),y,w.k(C.aK,x),null)
w.r=x
w.f.n(0,x,v.e)
w.E(y)
return new D.B(w,y,w.r,[F.lc])},
q:function(){this.f.i()},
v:function(){this.f.j()
this.r.d.F()}}
R.jy.prototype={
ZN:function(){return this.a++}}
A.Ny.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.b,g=j.a0(),f=document,e=T.d(f,g,"h2")
j.l(e)
T.b(e,"SimpleHTML with default URI whitelist")
y=T.d(f,g,"p")
j.l(y)
x=G.lj(j,3)
j.f=x
w=x.a
y.appendChild(w)
j.h(w)
x=j.d
v=j.e.z
u=F.le(x.m(C.b,v),w,x.k(C.aK,v),i)
j.r=u
j.f.J(u)
t=T.d(f,g,"ul")
j.h(t)
s=T.d(f,t,"li")
j.l(s)
u=G.lj(j,6)
j.x=u
r=u.a
s.appendChild(r)
j.h(r)
u=F.le(x.m(C.b,v),r,x.k(C.aK,v),i)
j.y=u
j.x.J(u)
q=T.d(f,t,"li")
j.l(q)
u=G.lj(j,8)
j.z=u
p=u.a
q.appendChild(p)
j.h(p)
u=F.le(x.m(C.b,v),p,x.k(C.aK,v),i)
j.Q=u
j.z.J(u)
o=T.d(f,g,"p")
j.l(o)
T.b(o,"The following message is removed due to disallowed HTML: [")
u=G.lj(j,11)
j.ch=u
n=u.a
o.appendChild(n)
j.h(n)
u=F.le(x.m(C.b,v),n,x.k(C.aK,v),i)
j.cx=u
j.ch.J(u)
T.b(o,"]")
m=T.d(f,g,"p")
j.l(m)
u=G.lj(j,14)
j.cy=u
l=u.a
m.appendChild(l)
j.M(l,"click-target")
j.h(l)
u=F.le(x.m(C.b,v),l,x.k(C.aK,v),i)
j.db=u
j.cy.J(u)
u=G.a7y(j,15)
j.dx=u
k=u.a
g.appendChild(k)
j.h(k)
x=F.a4n(x.m(C.b,v),k,x.k(C.aK,v),i)
j.dy=x
j.dx.J(x)
x=j.db.c
j.a8(C.O,H.a([new P.o(x,[H.e(x,0)]).B(j.ab(h.gZM(),W.a6))],[[P.N,-1]]))},
q:function(){var y,x,w,v,u,t,s,r,q,p,o=this,n=null,m=o.b
m.toString
y=[P.k]
x=H.a(["<b>","</b>",'<span class="highlight">',"</span>"],y)
w=$.aF().bt('I <b>love</b> using <span class="highlight">HTML</span>.',n,"SimpleHtmlExampleMessages_messageWithFormatting",x,n)
x=o.fr
if(x!=w){o.r.sfV(w)
o.fr=w
v=!0}else v=!1
if(v)o.f.e.st(1)
x=H.a(['<a href="localpage.html?param=1#test_fragment">',"</a>"],y)
u=$.aF().bt('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',n,"SimpleHtmlExampleMessages_messageLink",x,n)
x=o.fx
if(x!=u){o.y.sfV(u)
o.fx=u
v=!0}else v=!1
if(v)o.x.e.st(1)
x=H.a(['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],y)
t=$.aF().bt('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',n,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",x,n)
x=o.fy
if(x!=t){o.Q.sfV(t)
o.fy=t
v=!0}else v=!1
if(v)o.z.e.st(1)
x=H.a(['<a href="https://hecuba.org">',"</a>"],y)
s=$.aF().bt('Please consult my <a href="https://hecuba.org">suspicious website</a>.',n,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",x,n)
x=o.go
if(x!=s){o.cx.sfV(s)
o.go=s
v=!0}else v=!1
if(v)o.ch.e.st(1)
x=m.a
r='You <a class="trigger">clicked here</a> '+x+" times."
x=H.a([x,'<a class="trigger">',"</a>"],y)
q=$.aF().bt(r,n,"SimpleHtmlExampleMessages_messageWithClickHandler",x,n)
x=o.id
if(x!=q){o.db.sfV(q)
o.id=q
v=!0}else v=!1
if(v)o.cy.e.st(1)
y=H.a(["<b>","</b>","<ul>","</ul>","<li>","</li>"],y)
p=$.aF().bt("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",n,"SimpleHtmlExampleMessages_blockMessage",y,n)
y=o.k1
if(y!=p){o.dy.sfV(p)
o.k1=p
v=!0}else v=!1
if(v)o.dx.e.st(1)
o.f.i()
o.x.i()
o.z.i()
o.ch.i()
o.cy.i()
o.dx.i()},
v:function(){var y=this
y.f.j()
y.x.j()
y.z.j()
y.ch.j()
y.cy.j()
y.dx.j()
y.r.d.F()
y.y.d.F()
y.Q.d.F()
y.cx.d.F()
y.db.d.F()
y.dy.d.F()}}
A.Xm.prototype={
p:function(){var y,x,w=this,v=new A.Ny(w,S.h(3,C.i,0)),u=$.a7C
if(u==null)u=$.a7C=O.O($.aBs,null)
v.c=u
y=document.createElement("simple-html-example")
v.a=y
w.f=v
x=new R.jy()
w.r=x
v.n(0,x,w.e.e)
w.E(y)
return new D.B(w,y,w.r,[R.jy])},
q:function(){this.f.i()},
v:function(){this.f.j()}}
S.lf.prototype={}
F.Nx.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o=this,n="(removed)",m=o.a0(),l=document
T.b(T.d(l,m,"h2"),"SimpleHTML with a custom URI whitelist")
y=T.d(l,m,"ul")
x=T.d(l,y,"li")
w=G.lj(o,4)
o.f=w
v=w.a
x.appendChild(v)
w=o.d
u=o.e.z
t=F.le(w.m(C.b,u),v,w.k(C.aK,u),null)
o.r=t
o.f.J(t)
s=T.d(l,y,"li")
t=G.lj(o,6)
o.x=t
r=t.a
s.appendChild(r)
t=F.le(w.m(C.b,u),r,w.k(C.aK,u),null)
o.y=t
o.x.J(t)
T.b(s,n)
q=T.d(l,y,"li")
t=G.lj(o,9)
o.z=t
p=t.a
q.appendChild(p)
w=F.le(w.m(C.b,u),p,w.k(C.aK,u),null)
o.Q=w
o.z.J(w)
T.b(q,n)
o.ae()},
q:function(){var y,x,w,v,u,t=this,s="</a>"
t.b.toString
y=C.cc.qr('<a href="'+H.w(P.o6(C.cv,"https://wordpress.org/plugins/amp/",C.aO,!1))+'">',s)
x=t.ch
if(x!=y){t.r.sfV(y)
t.ch=y
w=!0}else w=!1
if(w)t.f.e.st(1)
v=C.cc.qr('<a href="'+H.w(P.o6(C.cv,"https://wordpress.org/plugins/malware/",C.aO,!1))+'">',s)
x=t.cx
if(x!=v){t.y.sfV(v)
t.cx=v
w=!0}else w=!1
if(w)t.x.e.st(1)
u=C.cc.qr('<a href="'+H.w(P.o6(C.cv,"javascript:alert('!')",C.aO,!1))+'">',s)
x=t.cy
if(x!=u){t.Q.sfV(u)
t.cy=u
w=!0}else w=!1
if(w)t.z.e.st(1)
t.f.i()
t.x.i()
t.z.i()},
v:function(){var y=this
y.f.j()
y.x.j()
y.z.j()
y.r.d.F()
y.y.d.F()
y.Q.d.F()}}
F.Xl.prototype={
p:function(){var y,x,w=this,v=new F.Nx(w,S.h(3,C.i,0)),u=$.a7B
if(u==null){u=new O.b3(null,C.a,"","","")
u.bB()
$.a7B=u}v.c=u
y=document.createElement("simple-html-custom-whitelist-example")
v.a=y
w.f=v
x=new S.lf()
w.r=x
v.n(0,x,w.e.e)
w.E(y)
return new D.B(w,y,w.r,[S.lf])},
N:function(d,e,f){var y
if(d===C.aK&&0===e){y=this.x
if(y==null){y=P.ew
y=this.x=P.lX(H.a([P.a7Z("https","developers.google.com","",null),P.a7Z("https","wordpress.org","plugins/amp/",null)],[y]),y)}return y}return f},
q:function(){this.f.i()},
v:function(){this.f.j()}}
Y.IS.prototype={
qr:function(d,e){var y="Visit "+d+"this site"+d+"!",x=H.a([d,e],[P.k])
return $.aF().bt(y,null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",x,null)}}
G.h5.prototype={}
E.Nu.prototype={
glU:function(){var y=this.x
return y==null?this.x=document:y},
gwf:function(){var y=this.z
return y==null?this.z=window:y},
glV:function(){var y,x=this,w=x.Q
if(w==null){w=x.d
y=x.e.z
y=T.b4(w.k(C.b,y),w.k(C.G,y),w.m(C.h,y),x.gwf())
x.Q=y
w=y}return w},
gw3:function(){var y,x=this,w=x.ch
if(w==null){w=x.d.m(C.Z,x.e.z)
y=x.glV()
w=x.ch=new O.aH(w,y)}return w},
gp9:function(){var y=this,x=y.cx
return x==null?y.cx=new K.aM(y.glU(),y.glV(),P.b_(null,[P.q,P.j])):x},
gIO:function(){var y=this,x=y.cy
if(x==null){x=T.b7(y.d.m(C.h,y.e.z))
y.cy=x}return x},
gte:function(){var y=this,x=y.db
if(x==null){x=G.bb(y.d.k(C.w,y.e.z))
y.db=x}return x},
gCz:function(){var y=this,x=y.dx
if(x==null){x=G.bd(y.glU(),y.d.k(C.x,y.e.z))
y.dx=x}return x},
gCA:function(){var y=this,x=y.dy
if(x==null){x=G.b6(y.gte(),y.gCz(),y.d.k(C.v,y.e.z))
y.dy=x}return x},
gtf:function(){var y=this.fr
return y==null?this.fr=!0:y},
gCB:function(){var y=this.fx
return y==null?this.fx=!0:y},
gw8:function(){var y=this.go
if(y==null){y=this.glU()
y=this.go=new R.aK(y.querySelector("head"),y)}return y},
gwg:function(){var y=this.id
return y==null?this.id=X.ba():y},
gw7:function(){var y=this,x=y.k1
return x==null?y.k1=K.b8(y.gw8(),y.gCA(),y.gte(),y.gp9(),y.glV(),y.gw3(),y.gtf(),y.gCB(),y.gwg()):x},
gIQ:function(){var y,x,w,v,u=this,t=u.k2
if(t==null){t=u.d
y=u.e.z
x=t.m(C.h,y)
w=u.gtf()
v=u.gw7()
t.k(C.n,y)
t=u.k2=new X.aG(w,x,v)}return t},
p:function(){var y,x=this,w=x.a0(),v=K.c3(x,0)
x.f=v
w.appendChild(v.a)
v=x.d
y=x.e.z
v.m(C.af,y)
y=v.m(C.ag,y)
v=new X.bB(y,!J.bs(window.location.href,"enableLatencyCharts=false"))
x.r=v
x.f.J(v)
x.ae()},
N:function(d,e,f){var y,x=this
if(0===e){if(d===C.Q)return x.glU()
if(d===C.a_){y=x.y
return y==null?x.y=document:y}if(d===C.M)return x.gwf()
if(d===C.b)return x.glV()
if(d===C.T)return x.gw3()
if(d===C.R)return x.gp9()
if(d===C.a0)return x.gIO()
if(d===C.w)return x.gte()
if(d===C.x)return x.gCz()
if(d===C.v)return x.gCA()
if(d===C.Y)return x.gtf()
if(d===C.I)return x.gCB()
if(d===C.J){y=x.fy
return y==null?x.fy=C.a3:y}if(d===C.W)return x.gw8()
if(d===C.H)return x.gwg()
if(d===C.V)return x.gw7()
if(d===C.n)return x.gIQ()
if(d===C.K){y=x.k3
return y==null?x.k3=C.a4:y}if(d===C.z){y=x.k4
return y==null?x.k4=new K.aS(x.gp9()):y}}return f},
q:function(){var y=this,x=y.b.a,w=y.r1
if(w!==x)y.r1=y.r.a=x
y.f.i()},
v:function(){this.f.j()}}
E.Xi.prototype={
p:function(){var y,x,w,v=this,u="angular_components/lib/simple_html/simple_html.dart",t=new E.Nu(v,S.h(3,C.i,0)),s=$.a7x
if(s==null){s=new O.b3(null,C.a,"","","")
s.bB()
$.a7x=s}t.c=s
y=document.createElement("simple-html-api")
t.a=y
v.f=t
t=[D.bU]
t=H.a([new D.iN("README","angular_components/lib/simple_html/README.md",X.f('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p><ul><li>  Light formatting (bold, italic, newlines).</li><li>  Links to external domains (with a customisable whitelist).</li><li>  Arbitrary click handlers on substrings within the text.</li></ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p><ul><li>  Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li><li>  Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li></ul>\n<p>The alternatives include:</p><ul><li>  Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.<ul><li>  This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li></ul></li><li>  Using the <code>[innerHtml]</code> directive with a string argument.<ul><li>  This is secure but very strict; only very limited tags are allowed.</li><li>  The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li><li>  The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li></ul></li><li>  Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.<ul><li>  This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li></ul></li></ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p><ol><li>\n<p> Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p></li><li>\n<p> Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p></li><li>\n<p> Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p></li><li>\n<p> Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p></li></ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p><ul><li>  <code>&lt;simple-html&gt;</code> supports the following safe inline elements:<ul><li>  Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li><li>  Line breaks: <code>&lt;br&gt;</code>.</li><li>  Text grouping: <code>&lt;span&gt;</code>.</li><li>  Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>, points to\ncertain permitted URIs such as the Help Center, or uses the\n<code>doNotVerifyUrlDestinations</code> flag; see\n(<a href="#uri-whitelisting">URI whitelisting</a>).<ul><li>  The <code>rel</code> attributes are permitted.</li><li>  The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li><li>  The <code>title</code> attribute is permitted.</li></ul></li></ul></li><li>  <code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:<ul><li>  Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li><li>  Paragraphs: <code>&lt;p&gt;</code>.</li></ul></li></ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h4>Allowing external URIs without a whitelist</h4>\n<p>There are cases where you can not use a whitelist:</p><ul><li>  when exposing a whitelist through client code is not acceptable, or</li><li>  the whitelist is not fixed</li></ul>\n<p>When the URIs come from a <em>safe</em> source, such as internally sourced URIs, you\ncan consider enabling the <code>doNotVerifyUrlDestinations</code> flag. This will allow any\nURI with the <code>http</code>, <code>https</code> or <code>mailto</code> scheme to be inserted, and should\ntherefore be used with caution.</p>\n<p>For example:</p>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html doNotVerifyUrlDestinations\n               [contents]="internalMessages.someMessage"&gt;&lt;/simple-html&gt;\n&lt;/my-template&gt;\n</code></pre>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p><ul><li>  Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li><li>  Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li></ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p><ul><li>  Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li><li>  More dangerous cases (such as setting the URL of an iframe) must still be\ndone using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at all.)</li></ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p><ol><li> Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li><li> Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular/Component-class.html">@Component</a>\'s\ndirective list.</li><li> For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li><li> In your template file, bind the message with either:<ul><li>  <code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span\n[innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li><li>  <code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li></ul></li><li> Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li><li> Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li><li> If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li></ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p><ul><li>  <strong>The message appears empty</strong><ul><li>  Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li></ul></li></ul>\n')),D.av("SimpleHtmlComponent",!1,"","simple-html","",u,X.f('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p><ul><li>  <code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li><li>  <code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li></ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the attribute doNotVerifyUrlDestinations is present, external URLs will\nnot be verified, except for their URI scheme. This is flag should only ever\nbe used for URLs that come from a safe source, such as internal\ndocumentation.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([D.i("Input","contents","","String",X.f("<p>HTML to display in the component.</p>\n"),u,!1,"")],t),H.a([D.i("Output","trigger","","Stream<UIEvent>",X.f("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),u,!1,"")],t))],[D.bO])
x=H.a([new R.aa(C.e9,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.aa(C.ev,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],[R.aa])
w=P.j
w=new G.h5(R.c8(H.a([],[w]),x,t,P.ak(w,w),!0))
v.r=w
v.f.n(0,w,v.e.e)
v.E(y)
return new D.B(v,y,v.r,[G.h5])},
q:function(){this.f.i()},
v:function(){this.f.j()}}
var z=a.updateTypes([{func:1,ret:-1},{func:1,ret:[S.m,F.ld]},{func:1,ret:[S.m,F.lc]},{func:1,ret:[S.m,R.jy]},{func:1,ret:[S.m,S.lf]},{func:1,ret:[S.m,G.h5]}])
F.PP.prototype={
$0:function(){var y,x,w,v=this.a
if(v.b==null)v.b=v.gGJ(v)
v.d.F()
x=v.b
if(x==null)return
try{J.ajO(x,this.b,v.e)}catch(w){y=H.aA(w)
if(y instanceof F.wW)$.a2P().jC(C.f_,"simple-html used untrusted URI: "+H.w(y),y,null)
else if(y instanceof F.vD)$.a2P().jC(C.f_,"simple-html used malformed element: "+H.w(y),y,null)
else throw w}v.a.dm(new F.PO(v))},
$S:0}
F.PO.prototype={
$0:function(){var y=this.a,x=W.at
new H.cj(new W.jK(y.b.querySelectorAll("a.trigger"),[x]),new F.PN(y),[x,[P.N,W.ax]]).aY(0,H.mS(y.d.gDZ(),W.ax))},
$S:0}
F.PN.prototype={
$1:function(d){var y=J.ajv(d),x=this.a.c
return W.bZ(y.a,y.b,x.gis(x),!1,H.e(y,0))},
$S:170}
F.PK.prototype={
$1:function(d){var y=d.gcZ(d).length===0||C.f.j8(d.gcZ(d),"/"),x="Whitelisted URIs with a path must end with a slash, which "+d.L(0)+" does not"
if(!y)H.L(P.cv(N.anx(x,null)))
return},
$S:171}
F.PJ.prototype={
$1:function(d){var y=this.a
return d.glo(d)===y.glo(y)&&C.f.cd(y.gcZ(y),d.gcZ(d))},
$S:172};(function installTearOffs(){var y=a._static_0,x=a._instance_0u
y(G,"azg","aJe",1)
y(G,"azf","aJd",2)
x(R.jy.prototype,"gZM","ZN",0)
y(A,"aze","aJg",3)
y(F,"azd","aJf",4)
y(E,"apZ","aJc",5)})();(function inheritance(){var y=a.inherit,x=a.inheritMany
y(P.Qe,P.wu)
x(P.k,[F.PM,F.ww,F.PI,F.OA,R.jy,S.lf,Y.IS,G.h5])
x(F.PM,[F.ld,F.lc])
x(H.aW,[F.PP,F.PO,F.PN,F.PK,F.PJ])
x(P.ej,[F.wW,F.vD])
x(S.m,[G.Nw,G.Xk,G.Nv,G.Xj,A.Ny,A.Xm,F.Nx,F.Xl,E.Nu,E.Xi])})();(function constants(){var y=a.makeConstList
C.cc=new Y.IS()
C.iB=new D.z("simple-html",G.azg(),[F.ld])
C.e9=new D.z("simple-html-example",A.aze(),[R.jy])
C.eh=new D.z("simple-html-api",E.apZ(),[G.h5])
C.ev=new D.z("simple-html-custom-whitelist-example",F.azd(),[S.lf])
C.j_=new D.z("simple-html-block",G.azf(),[F.lc])
C.cv=H.a(y([0,0,65498,45055,65535,34815,65534,18431]),[P.C])
C.aK=new S.dg("simpleHtmlUriWhitelist",[[P.q,P.ew]])
C.lq=H.a(y(["http","https","mailto"]),[P.j])
C.lV=new H.c0(3,{http:null,https:null,mailto:null},C.lq,[P.j,P.K])
C.mj=new P.Qe(C.lV,[P.j])
C.oS=H.x(G.h5)
C.oT=H.x(F.lc)
C.oU=H.x(F.ld)
C.oV=H.x(R.jy)
C.pu=H.x(S.lf)})();(function staticFields(){$.ahx=["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]
$.a7A=null
$.a7z=null
$.a8A=!1
$.aBx=["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]
$.a7C=null
$.abL=!1
$.a7B=null
$.a8z=!1
$.a7x=null
$.a8y=!1
$.aBr=[$.ahx]
$.aBq=[$.ahx]
$.aBs=[$.aBx]})();(function lazyInitializers(){var y=a.lazy
y($,"aLC","a2U",function(){var x=P.ew
return P.lX(H.a([],[x]),x)})
y($,"aLp","a2P",function(){return N.t4("_SimpleHtmlBase")})})()}
$__dart_deferred_initializers__["bl/nqMeZtUcwlcXRSSjbOoPFVqI="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_69.part.js.map
