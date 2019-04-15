self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={Q6:function Q6(d,e){this.a=d
this.$ti=e},
a7T:function(d,e,f,g){var y,x,w,v,u,t,s,r=null,q=e.length
if(q!==0){w=0
while(!0){if(!(w<q)){y=""
x=0
break}if(C.f.bF(e,w)===64){y=C.f.b6(e,0,w)
x=w+1
break}++w}if(x<q&&C.f.bF(e,x)===91){for(v=x;v<q;++v)if(C.f.bF(e,v)===93)break
if(v===q)throw H.o(P.bw("Invalid IPv6 host entry.",e,x))
P.a0E(e,x+1,v);++v
if(v!==q&&C.f.bF(e,v)!==58)throw H.o(P.bw("Invalid end of authority",e,v))}else v=x
while(!0){if(!(v<q)){u=r
break}if(C.f.bF(e,v)===58){t=C.f.cq(e,v+1)
u=t.length!==0?P.et(t,r,r):r
break}++v}s=C.f.b6(e,x,v)}else{u=r
s=u
y=""}return P.amf(s,r,H.a(f.split("/"),[P.k]),u,g,d,y)}},W,G={
ll:function(d,e){var y,x=new G.No(d,S.i(1,C.i,e)),w=$.a7u
if(w==null)w=$.a7u=O.O($.aBi,null)
x.c=w
y=document.createElement("simple-html")
x.a=y
return x},
aJ5:function(d,e){return new G.Xc(d,S.i(3,C.j,e))},
a7s:function(d,e){var y,x=new G.Nn(d,S.i(1,C.i,e)),w=$.a7t
if(w==null)w=$.a7t=O.O($.aBh,null)
x.c=w
y=document.createElement("simple-html-block")
x.a=y
return x},
aJ4:function(d,e){return new G.Xb(d,S.i(3,C.j,e))},
agH:function(){if($.a8v)return
$.a8v=!0
$.H.C(0,C.oV,C.iC)
$.H.C(0,C.oU,C.j0)
E.B()
V.dl()},
No:function No(d,e){var _=this
_.c=_.b=_.a=null
_.d=d
_.e=e},
Xc:function Xc(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e},
Nn:function Nn(d,e){var _=this
_.c=_.b=_.a=null
_.d=d
_.e=e},
Xb:function Xb(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e},
fL:function fL(d){this.a=d}},Y={IL:function IL(){}},R={i9:function i9(){this.a=0}},K,V,S={ju:function ju(){}},N,E={
alv:function(){return C.eh},
aJ3:function(d,e){return new E.Xa(d,S.i(3,C.j,e))},
aqh:function(){if($.a8t)return
$.a8t=!0
$.H.C(0,C.oT,C.eh)
E.B()
K.cC()
D.ck()
A.arC()
F.asy()},
Nm:function Nm(d,e){var _=this
_.c=_.b=_.a=_.r1=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Xa:function Xa(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e}},M,Q,D,L,Z,O,A={
aJ7:function(d,e){return new A.Xe(d,S.i(3,C.j,e))},
arC:function(){if($.abR)return
$.abR=!0
$.H.C(0,C.oW,C.e9)
E.B()
G.agH()},
Nq:function Nq(d,e){var _=this
_.c=_.b=_.a=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Xe:function Xe(d,e){var _=this
_.c=_.b=_.a=_.r=_.f=null
_.d=d
_.e=e}},U,T,X,B,F={
lg:function(d,e,f,g){var y=null,x=f==null?$.a2N():f
x=F.a8e(x,E.eZ(g,!1))
return new F.jt(e,d,new P.z(y,y,[W.a6]),new R.J(y,y,y,y,!1,!1),new F.ww(x))},
a4i:function(d,e,f,g){var y,x=null,w=f==null?$.a2N():f
w=F.a8e(w,E.eZ(g,!1))
y=[P.k]
w.fT("p",H.a(["class"],y))
w.fT("ul",H.a(["class"],y))
w.fT("li",H.a(["class"],y))
return new F.js(e,d,new P.z(x,x,[W.a6]),new R.J(x,x,x,x,!1,!1),new F.ww(w))},
Q7:function(d,e){return new F.wW(!1,null,null,"Unsafe URI "+H.x(d)+" because "+e)},
P3:function(d,e){return new F.vD(!1,null,null,"Element "+H.x(d)+" was malformed: "+e)},
a8h:function(d){var y,x,w=null
try{w=P.a0D(d)}catch(y){H.aA(y)
x=F.Q7(d,"Could not parse")
throw H.o(x)}return P.a4q().oH(w)},
amc:function(d){var y=new F.PA(P.lY(d,P.eV))
y.IN(d)
return y},
a8e:function(d,e){var y=e?new F.Os():F.amc(d),x=new W.pD(H.a([],[W.hj])),w=[P.k]
x.E7("a",H.a(["class","href","rel","target","title"],w),y)
x.fT("b",H.a(["class"],w))
x.fT("br",H.a(["class"],w))
x.fT("em",H.a(["class"],w))
x.fT("i",H.a(["class"],w))
x.fT("span",H.a(["class"],w))
x.fT("strong",H.a(["class"],w))
return x},
jt:function jt(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
js:function js(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
PE:function PE(){},
PH:function PH(d,e){this.a=d
this.b=e},
PG:function PG(d){this.a=d},
PF:function PF(d){this.a=d},
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
PA:function PA(d){this.a=d},
PC:function PC(){},
PB:function PB(d){this.a=d},
Os:function Os(){},
aJ6:function(d,e){return new F.Xd(d,S.i(3,C.j,e))},
asy:function(){if($.a8u)return
$.a8u=!0
$.H.C(0,C.pv,C.ev)
E.B()
G.agH()},
Np:function Np(d,e){var _=this
_.c=_.b=_.a=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=null
_.d=d
_.e=e},
Xd:function Xd(d,e){var _=this
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
N=c[11]
E=a.updateHolder(c[12],E)
M=c[13]
Q=c[14]
D=c[15]
L=c[16]
Z=c[17]
O=c[18]
A=a.updateHolder(c[19],A)
U=c[20]
T=c[21]
X=c[22]
B=c[23]
F=a.updateHolder(c[24],F)
P.Q6.prototype={
aP:function(d,e){return J.a_U(this.a,e)},
gbe:function(d){return J.bP(J.a_X(this.a))},
gJ:function(d){return J.bB(this.a)},
O:function(d,e){throw H.o(P.ab("Cannot change unmodifiable set"))},
bn:function(d,e){throw H.o(P.ab("Cannot change unmodifiable set"))}}
F.jt.prototype={
gGH:function(d){var y=this.f,x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.nT(y,x)
y=y.gdB(y)}return y}}
F.js.prototype={
gGH:function(d){var y=this.f,x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.nT(y,x)
y=y.gdB(y)}return y}}
F.PE.prototype={
sfU:function(d){this.a.cJ(new F.PH(this,d))}}
F.wW.prototype={}
F.vD.prototype={}
F.ww.prototype={
fe:function(d){if(!this.a.fe(d))throw H.o(F.P3(d,"prohibited element"))
return!0},
f_:function(d,e,f){var y
if(d.tagName.toLowerCase()==="a"&&e==="target"){if(!d.hasAttribute("rel"))throw H.o(F.P3(d,"did not set rel attribute"))
y=d.getAttribute("rel")
if(!C.e.aP(H.a(y.split(" "),[P.k]),"noopener"))throw H.o(F.P3(d,"did not set link type noopener (only "+y+")"))}if(!this.a.f_(d,e,f))throw H.o(F.P3(d,"prohibited attribute "+e+" with value "+H.x(f)))
return!0},
$ihj:1}
F.PA.prototype={
IN:function(d){C.e.aX(this.a,new F.PC())},
kR:function(d){var y,x,w,v=F.a8h(d),u=null
try{u=J.ajj(v)}catch(y){H.aA(y)
x=F.Q7(d,"Resolved URI "+H.x(v)+" had no origin")
throw H.o(x)}x=u
w=P.a4q()
if(!J.a0(x,w.glq(w))&&!this.Tf(v))throw H.o(F.Q7(d,"Different origin and non-whitelisted URL"))
return!0},
Tf:function(d){return C.e.e1(this.a,new F.PB(d))}}
F.Os.prototype={
kR:function(d){var y=F.a8h(d)
if(!J.a_U(C.mk.a,y.ghl()))throw H.o(F.Q7(d,"URI scheme "+H.x(y.ghl())+" not allowed"))
return!0}}
G.No.prototype={
p:function(){var y=this,x=y.a_(y.a)
y.l(T.d8(document,x))
y.ae()},
$ac:function(){return[F.jt]}}
G.Xc.prototype={
p:function(){var y,x=this,w=G.ll(x,0)
x.f=w
x.a=w.a
w=x.e
y=w.z
y=F.lg(x.n(C.b,y),x.a,x.k(C.aK,y),null)
x.r=y
x.f.m(0,y,w.e)
x.E(x.a)
return new D.C(x,0,x.a,x.r,[F.jt])},
q:function(){this.f.i()},
v:function(){this.f.j()
this.r.d.F()},
$ac:function(){return[F.jt]}}
G.Nn.prototype={
p:function(){var y=this,x=y.a_(y.a)
y.h(T.t(document,x))
y.ae()},
$ac:function(){return[F.js]}}
G.Xb.prototype={
p:function(){var y,x=this,w=G.a7s(x,0)
x.f=w
x.a=w.a
w=x.e
y=w.z
y=F.a4i(x.n(C.b,y),x.a,x.k(C.aK,y),null)
x.r=y
x.f.m(0,y,w.e)
x.E(x.a)
return new D.C(x,0,x.a,x.r,[F.js])},
q:function(){this.f.i()},
v:function(){this.f.j()
this.r.d.F()},
$ac:function(){return[F.js]}}
R.i9.prototype={
ZG:function(){return this.a++}}
A.Nq.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=null,h=j.b,g=j.a_(j.a),f=document,e=T.e(f,g,"h2")
j.l(e)
T.b(e,"SimpleHTML with default URI whitelist")
y=T.e(f,g,"p")
j.l(y)
x=G.ll(j,3)
j.f=x
w=x.a
y.appendChild(w)
j.h(w)
x=j.d
v=j.e.z
u=F.lg(x.n(C.b,v),w,x.k(C.aK,v),i)
j.r=u
j.f.I(u)
t=T.e(f,g,"ul")
j.h(t)
s=T.e(f,t,"li")
j.l(s)
u=G.ll(j,6)
j.x=u
r=u.a
s.appendChild(r)
j.h(r)
u=F.lg(x.n(C.b,v),r,x.k(C.aK,v),i)
j.y=u
j.x.I(u)
q=T.e(f,t,"li")
j.l(q)
u=G.ll(j,8)
j.z=u
p=u.a
q.appendChild(p)
j.h(p)
u=F.lg(x.n(C.b,v),p,x.k(C.aK,v),i)
j.Q=u
j.z.I(u)
o=T.e(f,g,"p")
j.l(o)
T.b(o,"The following message is removed due to disallowed HTML: [")
u=G.ll(j,11)
j.ch=u
n=u.a
o.appendChild(n)
j.h(n)
u=F.lg(x.n(C.b,v),n,x.k(C.aK,v),i)
j.cx=u
j.ch.I(u)
T.b(o,"]")
m=T.e(f,g,"p")
j.l(m)
u=G.ll(j,14)
j.cy=u
l=u.a
m.appendChild(l)
j.M(l,"click-target")
j.h(l)
u=F.lg(x.n(C.b,v),l,x.k(C.aK,v),i)
j.db=u
j.cy.I(u)
u=G.a7s(j,15)
j.dx=u
k=u.a
g.appendChild(k)
j.h(k)
x=F.a4i(x.n(C.b,v),k,x.k(C.aK,v),i)
j.dy=x
j.dx.I(x)
x=j.db.c
j.a7(C.O,H.a([new P.p(x,[H.f(x,0)]).B(j.ac(h.gZF(),W.a6))],[[P.N,-1]]))},
q:function(){var y,x,w,v,u,t,s,r,q,p,o=this,n=null,m=o.b
m.toString
y=[P.m]
x=H.a(["<b>","</b>",'<span class="highlight">',"</span>"],y)
w=$.aF().bv('I <b>love</b> using <span class="highlight">HTML</span>.',n,"SimpleHtmlExampleMessages_messageWithFormatting",x,n)
x=o.fr
if(x!=w){o.r.sfU(w)
o.fr=w
v=!0}else v=!1
if(v)o.f.e.st(1)
x=H.a(['<a href="localpage.html?param=1#test_fragment">',"</a>"],y)
u=$.aF().bv('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',n,"SimpleHtmlExampleMessages_messageLink",x,n)
x=o.fx
if(x!=u){o.y.sfU(u)
o.fx=u
v=!0}else v=!1
if(v)o.x.e.st(1)
x=H.a(['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],y)
t=$.aF().bv('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',n,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",x,n)
x=o.fy
if(x!=t){o.Q.sfU(t)
o.fy=t
v=!0}else v=!1
if(v)o.z.e.st(1)
x=H.a(['<a href="https://hecuba.org">',"</a>"],y)
s=$.aF().bv('Please consult my <a href="https://hecuba.org">suspicious website</a>.',n,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",x,n)
x=o.go
if(x!=s){o.cx.sfU(s)
o.go=s
v=!0}else v=!1
if(v)o.ch.e.st(1)
x=m.a
r='You <a class="trigger">clicked here</a> '+x+" times."
x=H.a([x,'<a class="trigger">',"</a>"],y)
q=$.aF().bv(r,n,"SimpleHtmlExampleMessages_messageWithClickHandler",x,n)
x=o.id
if(x!=q){o.db.sfU(q)
o.id=q
v=!0}else v=!1
if(v)o.cy.e.st(1)
y=H.a(["<b>","</b>","<ul>","</ul>","<li>","</li>"],y)
p=$.aF().bv("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",n,"SimpleHtmlExampleMessages_blockMessage",y,n)
y=o.k1
if(y!=p){o.dy.sfU(p)
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
y.dy.d.F()},
$ac:function(){return[R.i9]}}
A.Xe.prototype={
p:function(){var y,x=this,w=new A.Nq(x,S.i(3,C.i,0)),v=$.a7w
if(v==null)v=$.a7w=O.O($.aBj,null)
w.c=v
y=document.createElement("simple-html-example")
w.a=y
x.f=w
x.a=y
y=new R.i9()
x.r=y
w.m(0,y,x.e.e)
x.E(x.a)
return new D.C(x,0,x.a,x.r,[R.i9])},
q:function(){this.f.i()},
v:function(){this.f.j()},
$ac:function(){return[R.i9]}}
S.ju.prototype={}
F.Np.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o=this,n="(removed)",m=o.a_(o.a),l=document
T.b(T.e(l,m,"h2"),"SimpleHTML with a custom URI whitelist")
y=T.e(l,m,"ul")
x=T.e(l,y,"li")
w=G.ll(o,4)
o.f=w
v=w.a
x.appendChild(v)
w=o.d
u=o.e.z
t=F.lg(w.n(C.b,u),v,w.k(C.aK,u),null)
o.r=t
o.f.I(t)
s=T.e(l,y,"li")
t=G.ll(o,6)
o.x=t
r=t.a
s.appendChild(r)
t=F.lg(w.n(C.b,u),r,w.k(C.aK,u),null)
o.y=t
o.x.I(t)
T.b(s,n)
q=T.e(l,y,"li")
t=G.ll(o,9)
o.z=t
p=t.a
q.appendChild(p)
w=F.lg(w.n(C.b,u),p,w.k(C.aK,u),null)
o.Q=w
o.z.I(w)
T.b(q,n)
o.ae()},
q:function(){var y,x,w,v,u,t=this,s="</a>"
t.b.toString
y=C.cb.qt('<a href="'+H.x(P.o3(C.cu,"https://wordpress.org/plugins/amp/",C.aO,!1))+'">',s)
x=t.ch
if(x!=y){t.r.sfU(y)
t.ch=y
w=!0}else w=!1
if(w)t.f.e.st(1)
v=C.cb.qt('<a href="'+H.x(P.o3(C.cu,"https://wordpress.org/plugins/malware/",C.aO,!1))+'">',s)
x=t.cx
if(x!=v){t.y.sfU(v)
t.cx=v
w=!0}else w=!1
if(w)t.x.e.st(1)
u=C.cb.qt('<a href="'+H.x(P.o3(C.cu,"javascript:alert('!')",C.aO,!1))+'">',s)
x=t.cy
if(x!=u){t.Q.sfU(u)
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
y.Q.d.F()},
$ac:function(){return[S.ju]}}
F.Xd.prototype={
p:function(){var y,x=this,w=new F.Np(x,S.i(3,C.i,0)),v=$.a7v
if(v==null){v=new O.b4(null,C.a,"","","")
v.bC()
$.a7v=v}w.c=v
y=document.createElement("simple-html-custom-whitelist-example")
w.a=y
x.f=w
x.a=y
y=new S.ju()
x.r=y
w.m(0,y,x.e.e)
x.E(x.a)
return new D.C(x,0,x.a,x.r,[S.ju])},
N:function(d,e,f){var y
if(d===C.aK&&0===e){y=this.x
if(y==null){y=P.eV
y=this.x=P.lY(H.a([P.a7T("https","developers.google.com","",null),P.a7T("https","wordpress.org","plugins/amp/",null)],[y]),y)}return y}return f},
q:function(){this.f.i()},
v:function(){this.f.j()},
$ac:function(){return[S.ju]}}
Y.IL.prototype={
qt:function(d,e){var y="Visit "+d+"this site"+d+"!",x=H.a([d,e],[P.m])
return $.aF().bv(y,null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",x,null)}}
G.fL.prototype={}
E.Nm.prototype={
glW:function(){var y=this.x
return y==null?this.x=document:y},
gwh:function(){var y=this.z
return y==null?this.z=window:y},
glX:function(){var y,x=this,w=x.Q
if(w==null){w=x.d
y=x.e.z
y=T.b5(w.k(C.b,y),w.k(C.G,y),w.n(C.h,y),x.gwh())
x.Q=y
w=y}return w},
gw5:function(){var y,x=this,w=x.ch
if(w==null){w=x.d.n(C.Z,x.e.z)
y=x.glX()
w=x.ch=new O.aH(w,y)}return w},
gpd:function(){var y=this,x=y.cx
return x==null?y.cx=new K.aM(y.glW(),y.glX(),P.b0(null,[P.r,P.k])):x},
gII:function(){var y=this,x=y.cy
if(x==null){x=T.b8(y.d.n(C.h,y.e.z))
y.cy=x}return x},
gtf:function(){var y=this,x=y.db
if(x==null){x=G.bc(y.d.k(C.w,y.e.z))
y.db=x}return x},
gCD:function(){var y=this,x=y.dx
if(x==null){x=G.be(y.glW(),y.d.k(C.x,y.e.z))
y.dx=x}return x},
gCE:function(){var y=this,x=y.dy
if(x==null){x=G.b7(y.gtf(),y.gCD(),y.d.k(C.v,y.e.z))
y.dy=x}return x},
gtg:function(){var y=this.fr
return y==null?this.fr=!0:y},
gCF:function(){var y=this.fx
return y==null?this.fx=!0:y},
gwa:function(){var y=this.go
if(y==null){y=this.glW()
y=this.go=new R.aK(y.querySelector("head"),y)}return y},
gwi:function(){var y=this.id
return y==null?this.id=X.bb():y},
gw9:function(){var y=this,x=y.k1
return x==null?y.k1=K.b9(y.gwa(),y.gCE(),y.gtf(),y.gpd(),y.glX(),y.gw5(),y.gtg(),y.gCF(),y.gwi()):x},
gIK:function(){var y,x,w,v,u=this,t=u.k2
if(t==null){t=u.d
y=u.e.z
x=t.n(C.h,y)
w=u.gtg()
v=u.gw9()
t.k(C.n,y)
t=u.k2=new X.aG(w,x,v)}return t},
p:function(){var y,x=this,w=x.a_(x.a),v=K.c7(x,0)
x.f=v
w.appendChild(v.a)
v=x.d
y=x.e.z
v.n(C.af,y)
y=v.n(C.ag,y)
v=new X.az(y,!J.bt(window.location.href,"enableLatencyCharts=false"))
x.r=v
x.f.I(v)
x.ae()},
N:function(d,e,f){var y,x=this
if(0===e){if(d===C.Q)return x.glW()
if(d===C.a_){y=x.y
return y==null?x.y=document:y}if(d===C.M)return x.gwh()
if(d===C.b)return x.glX()
if(d===C.T)return x.gw5()
if(d===C.R)return x.gpd()
if(d===C.a0)return x.gII()
if(d===C.w)return x.gtf()
if(d===C.x)return x.gCD()
if(d===C.v)return x.gCE()
if(d===C.Y)return x.gtg()
if(d===C.I)return x.gCF()
if(d===C.J){y=x.fy
return y==null?x.fy=C.a3:y}if(d===C.W)return x.gwa()
if(d===C.H)return x.gwi()
if(d===C.V)return x.gw9()
if(d===C.n)return x.gIK()
if(d===C.K){y=x.k3
return y==null?x.k3=C.a4:y}if(d===C.z){y=x.k4
return y==null?x.k4=new K.aS(x.gpd()):y}}return f},
q:function(){var y=this,x=y.b.a,w=y.r1
if(w!==x)y.r1=y.r.a=x
y.f.i()},
v:function(){this.f.j()},
$ac:function(){return[G.fL]}}
E.Xa.prototype={
p:function(){var y,x,w=this,v="angular_components/lib/simple_html/simple_html.dart",u=new E.Nm(w,S.i(3,C.i,0)),t=$.a7r
if(t==null){t=new O.b4(null,C.a,"","","")
t.bC()
$.a7r=t}u.c=t
y=document.createElement("simple-html-api")
u.a=y
w.f=u
w.a=y
u=[D.bY]
u=H.a([new D.k9("README","angular_components/lib/simple_html/README.md",X.h('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p><ul><li>  Light formatting (bold, italic, newlines).</li><li>  Links to external domains (with a customisable whitelist).</li><li>  Arbitrary click handlers on substrings within the text.</li></ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p><ul><li>  Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li><li>  Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li></ul>\n<p>The alternatives include:</p><ul><li>  Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.<ul><li>  This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li></ul></li><li>  Using the <code>[innerHtml]</code> directive with a string argument.<ul><li>  This is secure but very strict; only very limited tags are allowed.</li><li>  The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li><li>  The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li></ul></li><li>  Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.<ul><li>  This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li></ul></li></ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p><ol><li>\n<p> Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p></li><li>\n<p> Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p></li><li>\n<p> Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p></li><li>\n<p> Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p></li></ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p><ul><li>  <code>&lt;simple-html&gt;</code> supports the following safe inline elements:<ul><li>  Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li><li>  Line breaks: <code>&lt;br&gt;</code>.</li><li>  Text grouping: <code>&lt;span&gt;</code>.</li><li>  Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>, points to\ncertain permitted URIs such as the Help Center, or uses the\n<code>doNotVerifyUrlDestinations</code> flag; see\n(<a href="#uri-whitelisting">URI whitelisting</a>).<ul><li>  The <code>rel</code> attributes are permitted.</li><li>  The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li><li>  The <code>title</code> attribute is permitted.</li></ul></li></ul></li><li>  <code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:<ul><li>  Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li><li>  Paragraphs: <code>&lt;p&gt;</code>.</li></ul></li></ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h4>Allowing external URIs without a whitelist</h4>\n<p>There are cases where you can not use a whitelist:</p><ul><li>  when exposing a whitelist through client code is not acceptable, or</li><li>  the whitelist is not fixed</li></ul>\n<p>When the URIs come from a <em>safe</em> source, such as internally sourced URIs, you\ncan consider enabling the <code>doNotVerifyUrlDestinations</code> flag. This will allow any\nURI with the <code>http</code>, <code>https</code> or <code>mailto</code> scheme to be inserted, and should\ntherefore be used with caution.</p>\n<p>For example:</p>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html doNotVerifyUrlDestinations\n               [contents]="internalMessages.someMessage"&gt;&lt;/simple-html&gt;\n&lt;/my-template&gt;\n</code></pre>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p><ul><li>  Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li><li>  Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li></ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p><ul><li>  Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li><li>  More dangerous cases (such as setting the URL of an iframe) must still be\ndone using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at all.)</li></ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p><ol><li> Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li><li> Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular/Component-class.html">@Component</a>\'s\ndirective list.</li><li> For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li><li> In your template file, bind the message with either:<ul><li>  <code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span\n[innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li><li>  <code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li></ul></li><li> Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li><li> Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li><li> If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li></ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p><ul><li>  <strong>The message appears empty</strong><ul><li>  Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li></ul></li></ul>\n')),D.aw("SimpleHtmlComponent",!1,"","simple-html","",v,X.h('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p><ul><li>  <code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li><li>  <code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li></ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the attribute doNotVerifyUrlDestinations is present, external URLs will\nnot be verified, except for their URI scheme. This is flag should only ever\nbe used for URLs that come from a safe source, such as internal\ndocumentation.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([D.j("Input","contents","","String",X.h("<p>HTML to display in the component.</p>\n"),v,!1,"")],u),H.a([D.j("Output","trigger","","Stream<UIEvent>",X.h("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),v,!1,"")],u))],[D.bQ])
y=H.a([new R.aa(C.e9,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.aa(C.ev,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],[R.aa])
x=P.k
x=new G.fL(R.cb(H.a([],[x]),y,u,P.ak(x,x),!0))
w.r=x
w.f.m(0,x,w.e.e)
w.E(w.a)
return new D.C(w,0,w.a,w.r,[G.fL])},
q:function(){this.f.i()},
v:function(){this.f.j()},
$ac:function(){return[G.fL]}}
var z=a.updateTypes([{func:1,ret:-1},{func:1,ret:[S.c,F.jt],args:[[S.c,,],P.l]},{func:1,ret:[S.c,F.js],args:[[S.c,,],P.l]},{func:1,ret:[S.c,R.i9],args:[[S.c,,],P.l]},{func:1,ret:[S.c,S.ju],args:[[S.c,,],P.l]},{func:1,ret:[S.c,G.fL],args:[[S.c,,],P.l]}])
F.PH.prototype={
$0:function(){var y,x,w,v=this.a
if(v.b==null)v.b=v.gGH(v)
v.d.F()
x=v.b
if(x==null)return
try{J.ajA(x,this.b,v.e)}catch(w){y=H.aA(w)
if(y instanceof F.wW)$.a2I().jE(C.f_,"simple-html used untrusted URI: "+H.x(y),y,null)
else if(y instanceof F.vD)$.a2I().jE(C.f_,"simple-html used malformed element: "+H.x(y),y,null)
else throw w}v.a.dA(new F.PG(v))},
$S:0}
F.PG.prototype={
$0:function(){var y=this.a,x=W.at
new H.cp(new W.kC(y.b.querySelectorAll("a.trigger"),[x]),new F.PF(y),[x,[P.N,W.ax]]).aX(0,H.mR(y.d.gE3(),W.ax))},
$S:0}
F.PF.prototype={
$1:function(d){var y=J.ajh(d),x=this.a.c
return W.bU(y.a,y.b,x.git(x),!1,H.f(y,0))},
$S:170}
F.PC.prototype={
$1:function(d){var y=d.gcY(d).length===0||C.f.ja(d.gcY(d),"/"),x="Whitelisted URIs with a path must end with a slash, which "+d.L(0)+" does not"
if(!y)H.L(P.cD(N.anh(x,null)))
return},
$S:171}
F.PB.prototype={
$1:function(d){var y=this.a
return d.glq(d)===y.glq(y)&&C.f.ci(y.gcY(y),d.gcY(d))},
$S:172};(function installTearOffs(){var y=a._static_2,x=a._instance_0u
y(G,"az7","aJ5",1)
y(G,"az6","aJ4",2)
x(R.i9.prototype,"gZF","ZG",0)
y(A,"az5","aJ7",3)
y(F,"az4","aJ6",4)
y(E,"apJ","aJ3",5)})();(function inheritance(){var y=a.inherit,x=a.inheritMany
y(P.Q6,P.wu)
x(P.m,[F.PE,F.ww,F.PA,F.Os,R.i9,S.ju,Y.IL,G.fL])
x(F.PE,[F.jt,F.js])
x(H.aW,[F.PH,F.PG,F.PF,F.PC,F.PB])
x(P.eG,[F.wW,F.vD])
x(S.c,[G.No,G.Xc,G.Nn,G.Xb,A.Nq,A.Xe,F.Np,F.Xd,E.Nm,E.Xa])})();(function constants(){var y=a.makeConstList
C.cb=new Y.IL()
C.iC=new D.A("simple-html",G.az7(),[F.jt])
C.e9=new D.A("simple-html-example",A.az5(),[R.i9])
C.eh=new D.A("simple-html-api",E.apJ(),[G.fL])
C.ev=new D.A("simple-html-custom-whitelist-example",F.az4(),[S.ju])
C.j0=new D.A("simple-html-block",G.az6(),[F.js])
C.cu=H.a(y([0,0,65498,45055,65535,34815,65534,18431]),[P.l])
C.aK=new S.dH("simpleHtmlUriWhitelist",[[P.r,P.eV]])
C.lr=H.a(y(["http","https","mailto"]),[P.k])
C.lW=new H.c3(3,{http:null,https:null,mailto:null},C.lr,[P.k,P.K])
C.mk=new P.Q6(C.lW,[P.k])
C.oT=H.y(G.fL)
C.oU=H.y(F.js)
C.oV=H.y(F.jt)
C.oW=H.y(R.i9)
C.pv=H.y(S.ju)})();(function staticFields(){$.ahl=["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]
$.a7u=null
$.a7t=null
$.a8v=!1
$.aBo=["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]
$.a7w=null
$.abR=!1
$.a7v=null
$.a8u=!1
$.a7r=null
$.a8t=!1
$.aBi=[$.ahl]
$.aBh=[$.ahl]
$.aBj=[$.aBo]})();(function lazyInitializers(){var y=a.lazy
y($,"aLt","a2N",function(){var x=P.eV
return P.lY(H.a([],[x]),x)})
y($,"aLg","a2I",function(){return N.t4("_SimpleHtmlBase")})})()}
$__dart_deferred_initializers__["uDNDLzDIppj0pUX7FAe4n5wyzC8="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_69.part.js.map
