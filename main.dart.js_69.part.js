self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={
a7K:function(d,e,f,g){var y,x,w,v,u,t,s,r
y=e.length
if(y!==0){v=0
while(!0){if(!(v<y)){x=""
w=0
break}if(C.h.bL(e,v)===64){x=C.h.bG(e,0,v)
w=v+1
break}++v}if(w<y&&C.h.bL(e,w)===91){for(u=w;u<y;++u)if(C.h.bL(e,u)===93)break
if(u===y)throw H.l(P.bt("Invalid IPv6 host entry.",e,w))
P.a0U(e,w+1,u);++u
if(u!==y&&C.h.bL(e,u)!==58)throw H.l(P.bt("Invalid end of authority",e,u))}else u=w
while(!0){if(!(u<y)){t=null
break}if(C.h.bL(e,u)===58){s=C.h.cF(e,u+1)
t=s.length!==0?P.eD(s,null,null):null
break}++u}r=C.h.bG(e,w,u)}else{x=""
r=null
t=null}return P.apP(r,null,H.b(f.split("/"),[P.c]),t,g,d,x)}},W,G={
lq:function(d,e){var y,x
y=new G.Oc(P.e(P.c,null),d)
y.a=S.i(y,3,C.j,e,F.hN)
x=document.createElement("simple-html")
y.e=x
x=$.a7m
if(x==null){x=$.D
x=x.Y(null,C.m,$.akK())
$.a7m=x}y.X(x)
return y},
aJO:function(d,e){var y=new G.Xw(P.e(P.c,null),d)
y.a=S.i(y,3,C.k,e,F.hN)
return y},
a7k:function(d,e){var y,x
y=new G.Ob(P.e(P.c,null),d)
y.a=S.i(y,3,C.j,e,F.hM)
x=document.createElement("simple-html-block")
y.e=x
x=$.a7l
if(x==null){x=$.D
x=x.Y(null,C.m,$.akJ())
$.a7l=x}y.X(x)
return y},
aJN:function(d,e){var y=new G.Xv(P.e(P.c,null),d)
y.a=S.i(y,3,C.k,e,F.hM)
return y},
agz:function(){if($.a8j)return
$.a8j=!0
var y=$.F()
y.w(0,C.pu,C.iv)
y.w(0,C.pt,C.iU)
E.z()
V.du()},
Oc:function Oc(d,e){var _=this
_.a=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
Xw:function Xw(d,e){var _=this
_.a=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
Ob:function Ob(d,e){var _=this
_.a=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
Xv:function Xv(d,e){var _=this
_.a=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
fB:function fB(d){this.a=d}},Y={JH:function JH(){}},R={hO:function hO(){this.a=0}},K,V,S={iP:function iP(){}},N,E={
ap8:function(){return C.ee},
aJM:function(d,e){var y=new E.Xu(P.e(P.c,null),d)
y.a=S.i(y,3,C.k,e,G.fB)
return y},
atL:function(){if($.a8h)return
$.a8h=!0
$.F().w(0,C.ps,C.ee)
E.z()
K.cD()
D.cn()
A.av5()
F.aw_()},
Oa:function Oa(d,e){var _=this
_.a=_.r1=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
Xu:function Xu(d,e){var _=this
_.a=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null}},M,Q,D,L,Z,A={
aJQ:function(d,e){var y=new A.Xy(P.e(P.c,null),d)
y.a=S.i(y,3,C.k,e,R.hO)
return y},
av5:function(){if($.abF)return
$.abF=!0
$.F().w(0,C.pv,C.e6)
E.z()
G.agz()},
Oe:function Oe(d,e){var _=this
_.a=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
Xy:function Xy(d,e){var _=this
_.a=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null}},U,T,O,X,B,F={
ll:function(d,e,f){var y=F.a83(f==null?$.a3t():f)
return new F.hN(e,d,new P.x(null,null,0,[W.a2]),new R.E(!1),new F.x9(y))},
a5f:function(d,e,f){var y,x
y=F.a83(f==null?$.a3t():f)
x=[P.c]
y.fT("p",H.b(["class"],x))
y.fT("ul",H.b(["class"],x))
y.fT("li",H.b(["class"],x))
return new F.hM(e,d,new P.x(null,null,0,[W.a2]),new R.E(!1),new F.x9(y))},
a1E:function(d,e){return new F.xz(!1,null,null,"Unsafe URI "+H.u(d)+" because "+e)},
PN:function(d,e){return new F.wl(!1,null,null,"Element "+H.u(d)+" was malformed: "+e)},
apM:function(d){var y=new F.Qj(P.m5(d,P.fE))
y.JC(d)
return y},
a83:function(d){var y,x
y=new W.q6(H.b([],[W.hH]))
x=[P.c]
y.EJ("a",H.b(["class","href","rel","target"],x),F.apM(d))
y.fT("b",H.b(["class"],x))
y.fT("br",H.b(["class"],x))
y.fT("em",H.b(["class"],x))
y.fT("i",H.b(["class"],x))
y.fT("span",H.b(["class"],x))
y.fT("strong",H.b(["class"],x))
return y},
hN:function hN(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
hM:function hM(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
Qo:function Qo(){},
Qr:function Qr(d,e){this.a=d
this.b=e},
Qq:function Qq(d){this.a=d},
Qp:function Qp(d){this.a=d},
xz:function xz(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
wl:function wl(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
x9:function x9(d){this.a=d},
Qj:function Qj(d){this.a=d},
Ql:function Ql(){},
Qk:function Qk(d){this.a=d},
aJP:function(d,e){var y=new F.Xx(P.e(P.c,null),d)
y.a=S.i(y,3,C.k,e,S.iP)
return y},
aw_:function(){if($.a8i)return
$.a8i=!0
$.F().w(0,C.q3,C.es)
E.z()
G.agz()},
Od:function Od(d,e){var _=this
_.a=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null},
Xx:function Xx(d,e){var _=this
_.a=_.y=_.x=_.r=null
_.b=d
_.c=e
_.f=_.e=_.d=null}}
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
A=a.updateHolder(c[18],A)
U=c[19]
T=c[20]
O=c[21]
X=c[22]
B=c[23]
F=a.updateHolder(c[24],F)
F.hN.prototype={
gHy:function(d){var y,x
y=this.f
x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.ob(y,x)
y=y.gdz(y)}return y}}
F.hM.prototype={
gHy:function(d){var y,x
y=this.f
x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.ob(y,x)
y=y.gdz(y)}return y}}
F.Qo.prototype={
sfU:function(d){return this.a.cN(new F.Qr(this,d))}}
F.xz.prototype={}
F.wl.prototype={}
F.x9.prototype={
fh:function(d){if(!this.a.fh(d))throw H.l(F.PN(d,"prohibited element"))
return!0},
f2:function(d,e,f){var y
if(d.tagName.toLowerCase()==="a"&&e==="target"){if(!d.hasAttribute("rel"))throw H.l(F.PN(d,"did not set rel attribute"))
y=d.getAttribute("rel")
if(!C.e.aO(H.b(y.split(" "),[P.c]),"noopener"))throw H.l(F.PN(d,"did not set link type noopener (only "+y+")"))}if(!this.a.f2(d,e,f))throw H.l(F.PN(d,"prohibited attribute "+e+" with value "+H.u(f)))
return!0},
$ihH:1}
F.Qj.prototype={
JC:function(d){C.e.aX(this.a,new F.Ql())},
oe:function(d){var y,x,w,v,u,t
y=null
try{y=P.a0T(d)}catch(v){H.aw(v)
u=F.a1E(d,"Could not parse")
throw H.l(u)}x=P.a5n().p0(y)
w=null
try{w=J.amR(x)}catch(v){H.aw(v)
u=F.a1E(d,"Resolved URI "+H.u(x)+" had no origin")
throw H.l(u)}u=w
t=P.a5n()
if(!J.X(u,t.glL(t))&&!this.TU(x))throw H.l(F.a1E(d,"Different origin and non-whitelisted URL"))
return!0},
TU:function(d){return C.e.em(this.a,new F.Qk(d))}}
G.Oc.prototype={
p:function(){var y=this.Z(this.e)
this.m(S.d7(document,y))
this.J(C.a,null)},
$aa:function(){return[F.hN]}}
G.Xw.prototype={
p:function(){var y=G.lq(this,0)
this.r=y
this.e=y.e
y=F.ll(this.n(C.b,this.a.Q),this.e,this.l(C.aG,this.a.Q,null))
this.x=y
this.r.k(0,y,this.a.e)
this.D(this.e)
return new D.A(this,0,this.e,this.x,[F.hN])},
q:function(){this.r.j()},
v:function(){this.r.i()
this.x.d.E()},
$aa:function(){return[F.hN]}}
G.Ob.prototype={
p:function(){var y=this.Z(this.e)
this.h(S.p(document,y))
this.J(C.a,null)},
$aa:function(){return[F.hM]}}
G.Xv.prototype={
p:function(){var y=G.a7k(this,0)
this.r=y
this.e=y.e
y=F.a5f(this.n(C.b,this.a.Q),this.e,this.l(C.aG,this.a.Q,null))
this.x=y
this.r.k(0,y,this.a.e)
this.D(this.e)
return new D.A(this,0,this.e,this.x,[F.hM])},
q:function(){this.r.j()},
v:function(){this.r.i()
this.x.d.E()},
$aa:function(){return[F.hM]}}
R.hO.prototype={
a_b:function(){return this.a++}}
A.Oe.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i
y=this.Z(this.e)
x=document
w=S.d(x,"h2",y)
this.m(w)
w.appendChild(x.createTextNode("SimpleHTML with default URI whitelist"))
v=S.d(x,"p",y)
this.m(v)
u=G.lq(this,3)
this.r=u
t=u.e
v.appendChild(t)
this.h(t)
u=this.c
s=F.ll(u.n(C.b,this.a.Q),t,u.l(C.aG,this.a.Q,null))
this.x=s
this.r.k(0,s,[])
r=S.d(x,"ul",y)
this.h(r)
q=S.d(x,"li",r)
this.m(q)
s=G.lq(this,6)
this.y=s
p=s.e
q.appendChild(p)
this.h(p)
s=F.ll(u.n(C.b,this.a.Q),p,u.l(C.aG,this.a.Q,null))
this.z=s
this.y.k(0,s,[])
o=S.d(x,"li",r)
this.m(o)
s=G.lq(this,8)
this.Q=s
n=s.e
o.appendChild(n)
this.h(n)
s=F.ll(u.n(C.b,this.a.Q),n,u.l(C.aG,this.a.Q,null))
this.ch=s
this.Q.k(0,s,[])
m=S.d(x,"p",y)
this.m(m)
m.appendChild(x.createTextNode("The following message is removed due to disallowed HTML: ["))
s=G.lq(this,11)
this.cx=s
l=s.e
m.appendChild(l)
this.h(l)
s=F.ll(u.n(C.b,this.a.Q),l,u.l(C.aG,this.a.Q,null))
this.cy=s
this.cx.k(0,s,[])
m.appendChild(x.createTextNode("]"))
k=S.d(x,"p",y)
this.m(k)
s=G.lq(this,14)
this.db=s
j=s.e
k.appendChild(j)
j.className="click-target"
this.h(j)
s=F.ll(u.n(C.b,this.a.Q),j,u.l(C.aG,this.a.Q,null))
this.dx=s
this.db.k(0,s,[])
s=G.a7k(this,15)
this.dy=s
i=s.e
y.appendChild(i)
this.h(i)
u=F.a5f(u.n(C.b,this.a.Q),i,u.l(C.aG,this.a.Q,null))
this.fr=u
this.dy.k(0,u,[])
u=this.dx.c
this.J(C.a,[new P.m(u,[H.f(u,0)]).B(this.a6(this.f.ga_a(),W.a2))])},
q:function(){var y,x,w,v,u,t,s,r
y=this.f
y.toString
x=T.ae('I <b>love</b> using <span class="highlight">HTML</span>.',["<b>","</b>",'<span class="highlight">',"</span>"],"Example message describing using of HTML.",C.mB,null,"SimpleHtmlExampleMessages_messageWithFormatting",!0)
w=this.fx
if(w!=x){this.x.sfU(x)
this.fx=x}v=T.ae('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',['<a href="localpage.html?param=1#test_fragment">',"</a>"],"Example message containing a link to same-origin page.",C.cw,null,"SimpleHtmlExampleMessages_messageLink",!0)
w=this.fy
if(w!=v){this.z.sfU(v)
this.fy=v}u=T.ae('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],"Example message containing a link to a same-origin page that opens in a new window.",C.cw,null,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",!0)
w=this.go
if(w!=u){this.ch.sfU(u)
this.go=u}t=T.ae('Please consult my <a href="https://hecuba.org">suspicious website</a>.',['<a href="https://hecuba.org">',"</a>"],"Example message containing a link to an untrusted site.",C.cw,null,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",!0)
w=this.id
if(w!=t){this.cy.sfU(t)
this.id=t}w=y.a
s=T.ae('You <a class="trigger">clicked here</a> '+w+" times.",[w,'<a class="trigger">',"</a>"],"Example message containing a parameter",C.mp,null,"SimpleHtmlExampleMessages_messageWithClickHandler",!0)
w=this.k1
if(w!=s){this.dx.sfU(s)
this.k1=s}r=T.ae("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",["<b>","</b>","<ul>","</ul>","<li>","</li>"],"Example message describing using of block-level HTML.",C.mA,null,"SimpleHtmlExampleMessages_blockMessage",!0)
w=this.k2
if(w!=r){this.fr.sfU(r)
this.k2=r}this.r.j()
this.y.j()
this.Q.j()
this.cx.j()
this.db.j()
this.dy.j()},
v:function(){this.r.i()
this.y.i()
this.Q.i()
this.cx.i()
this.db.i()
this.dy.i()
this.x.d.E()
this.z.d.E()
this.ch.d.E()
this.cy.d.E()
this.dx.d.E()
this.fr.d.E()},
$aa:function(){return[R.hO]}}
A.Xy.prototype={
p:function(){var y,x,w
y=new A.Oe(P.e(P.c,null),this)
x=R.hO
y.a=S.i(y,3,C.j,0,x)
w=document.createElement("simple-html-example")
y.e=w
w=$.a7o
if(w==null){w=$.D
w=w.Y(null,C.m,$.akL())
$.a7o=w}y.X(w)
this.r=y
this.e=y.e
w=new R.hO()
this.x=w
y.k(0,w,this.a.e)
this.D(this.e)
return new D.A(this,0,this.e,this.x,[x])},
q:function(){this.r.j()},
v:function(){this.r.i()},
$aa:function(){return[R.hO]}}
S.iP.prototype={}
F.Od.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o
y=this.Z(this.e)
x=document
S.d(x,"h2",y).appendChild(x.createTextNode("SimpleHTML with a custom URI whitelist"))
w=S.d(x,"ul",y)
v=S.d(x,"li",w)
u=G.lq(this,4)
this.r=u
t=u.e
v.appendChild(t)
u=this.c
s=F.ll(u.n(C.b,this.a.Q),t,u.l(C.aG,this.a.Q,null))
this.x=s
this.r.k(0,s,[])
r=S.d(x,"li",w)
s=G.lq(this,6)
this.y=s
q=s.e
r.appendChild(q)
s=F.ll(u.n(C.b,this.a.Q),q,u.l(C.aG,this.a.Q,null))
this.z=s
this.y.k(0,s,[])
r.appendChild(x.createTextNode("(removed)"))
p=S.d(x,"li",w)
s=G.lq(this,9)
this.Q=s
o=s.e
p.appendChild(o)
u=F.ll(u.n(C.b,this.a.Q),o,u.l(C.aG,this.a.Q,null))
this.ch=u
this.Q.k(0,u,[])
p.appendChild(x.createTextNode("(removed)"))
this.J(C.a,null)},
q:function(){var y,x,w,v
this.f.toString
y=C.c7.qP('<a href="'+H.u(P.on(C.cr,"https://wordpress.org/plugins/amp/",C.aM,!1))+'">',"</a>")
x=this.cx
if(x!=y){this.x.sfU(y)
this.cx=y}w=C.c7.qP('<a href="'+H.u(P.on(C.cr,"https://wordpress.org/plugins/malware/",C.aM,!1))+'">',"</a>")
x=this.cy
if(x!=w){this.z.sfU(w)
this.cy=w}v=C.c7.qP('<a href="'+H.u(P.on(C.cr,"javascript:alert('!')",C.aM,!1))+'">',"</a>")
x=this.db
if(x!=v){this.ch.sfU(v)
this.db=v}this.r.j()
this.y.j()
this.Q.j()},
v:function(){this.r.i()
this.y.i()
this.Q.i()
this.x.d.E()
this.z.d.E()
this.ch.d.E()},
$aa:function(){return[S.iP]}}
F.Xx.prototype={
p:function(){var y,x,w
y=new F.Od(P.e(P.c,null),this)
x=S.iP
y.a=S.i(y,3,C.j,0,x)
w=document.createElement("simple-html-custom-whitelist-example")
y.e=w
w=$.a7n
if(w==null){w=$.D
w=w.Y(null,C.X,C.a)
$.a7n=w}y.X(w)
this.r=y
this.e=y.e
w=new S.iP()
this.x=w
y.k(0,w,this.a.e)
this.D(this.e)
return new D.A(this,0,this.e,this.x,[x])},
K:function(d,e,f){var y
if(d===C.aG&&0===e){y=this.y
if(y==null){y=P.fE
y=P.m5(H.b([P.a7K("https","developers.google.com","",null),P.a7K("https","wordpress.org","plugins/amp/",null)],[y]),y)
this.y=y}return y}return f},
q:function(){this.r.j()},
v:function(){this.r.i()},
$aa:function(){return[S.iP]}}
Y.JH.prototype={
qP:function(d,e){return T.ae("Visit "+d+"this site"+d+"!",[d,e],"Example message containing a link to a URI.",C.mw,null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",!0)}}
G.fB.prototype={}
E.Oa.prototype={
gmh:function(){var y=this.y
if(y==null){y=document
this.y=y}return y},
gx_:function(){var y=this.Q
if(y==null){y=window
this.Q=y}return y},
gmi:function(){var y=this.ch
if(y==null){y=this.c
y=T.aY(y.l(C.b,this.a.Q,null),y.l(C.D,this.a.Q,null),y.n(C.f,this.a.Q),this.gx_())
this.ch=y}return y},
gwN:function(){var y,x
y=this.cx
if(y==null){y=this.c.n(C.S,this.a.Q)
x=this.gmi()
y=new O.aC(y,x)
this.cx=y}return y},
gpy:function(){var y=this.cy
if(y==null){y=new K.aH(this.gmh(),this.gmi(),P.aU(null,[P.o,P.c]))
this.cy=y}return y},
gJx:function(){var y=this.db
if(y==null){y=T.b2(this.c.n(C.f,this.a.Q))
this.db=y}return y},
gtz:function(){var y=this.dx
if(y==null){y=G.b6(this.c.l(C.w,this.a.Q,null))
this.dx=y}return y},
gDh:function(){var y=this.dy
if(y==null){y=G.b9(this.gmh(),this.c.l(C.x,this.a.Q,null))
this.dy=y}return y},
gDi:function(){var y=this.fr
if(y==null){y=G.b1(this.gtz(),this.gDh(),this.c.l(C.v,this.a.Q,null))
this.fr=y}return y},
gtA:function(){var y=this.fx
if(y==null){this.fx=!0
y=!0}return y},
gDj:function(){var y=this.fy
if(y==null){this.fy=!0
y=!0}return y},
gwS:function(){var y=this.go
if(y==null){y=this.gmh()
y=new R.aF(y.querySelector("head"),y)
this.go=y}return y},
gx0:function(){var y=this.id
if(y==null){y=X.b4()
this.id=y}return y},
gwR:function(){var y=this.k1
if(y==null){y=K.b3(this.gwS(),this.gDi(),this.gtz(),this.gpy(),this.gmi(),this.gwN(),this.gtA(),this.gDj(),this.gx0())
this.k1=y}return y},
gJz:function(){var y,x,w,v
y=this.k2
if(y==null){y=this.c
x=y.n(C.f,this.a.Q)
w=this.gtA()
v=this.gwR()
y.l(C.n,this.a.Q,null)
y=new X.az(w,x,v)
this.k2=y}return y},
p:function(){var y,x
y=this.Z(this.e)
x=K.cd(this,0)
this.r=x
y.appendChild(x.e)
x=new X.af(!J.bp(window.location.href,"enableLatencyCharts=false"))
this.x=x
this.r.k(0,x,[])
this.J(C.a,null)},
K:function(d,e,f){var y
if(d===C.M&&0===e)return this.gmh()
if(d===C.T&&0===e){y=this.z
if(y==null){y=document
this.z=y}return y}if(d===C.I&&0===e)return this.gx_()
if(d===C.b&&0===e)return this.gmi()
if(d===C.O&&0===e)return this.gwN()
if(d===C.N&&0===e)return this.gpy()
if(d===C.U&&0===e)return this.gJx()
if(d===C.w&&0===e)return this.gtz()
if(d===C.x&&0===e)return this.gDh()
if(d===C.v&&0===e)return this.gDi()
if(d===C.R&&0===e)return this.gtA()
if(d===C.G&&0===e)return this.gDj()
if(d===C.Q&&0===e)return this.gwS()
if(d===C.F&&0===e)return this.gx0()
if(d===C.P&&0===e)return this.gwR()
if(d===C.n&&0===e)return this.gJz()
if(d===C.H&&0===e){y=this.k3
if(y==null){this.k3=C.A
y=C.A}return y}if(d===C.y&&0===e){y=this.k4
if(y==null){y=new K.aL(this.gpy())
this.k4=y}return y}return f},
q:function(){var y,x
y=this.f.a
x=this.r1
if(x!==y){this.x.a=y
this.r1=y}this.r.j()},
v:function(){this.r.i()},
$aa:function(){return[G.fB]}}
E.Xu.prototype={
p:function(){var y,x,w,v
y=P.c
x=new E.Oa(P.e(y,null),this)
w=G.fB
x.a=S.i(x,3,C.j,0,w)
v=document.createElement("simple-html-api")
x.e=v
v=$.a7j
if(v==null){v=$.D
v=v.Y(null,C.X,C.a)
$.a7j=v}x.X(v)
this.r=x
this.e=x.e
x=[D.c4]
x=H.b([new D.kd("README","angular_components/lib/simple_html/README.md",X.h('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p><ul><li>  Light formatting (bold, italic, newlines).</li><li>  Links to external domains (with a customisable whitelist).</li><li>  Arbitrary click handlers on substrings within the text.</li></ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p><ul><li>  Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li><li>  Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li></ul>\n<p>The alternatives include:</p><ul><li>  Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.<ul><li>  This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li></ul></li><li>  Using the <code>[innerHtml]</code> directive with a string argument.<ul><li>  This is secure but very strict; only very limited tags are allowed.</li><li>  The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li><li>  The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li></ul></li><li>  Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.<ul><li>  This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li></ul></li></ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p><ol><li>\n<p> Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p></li><li>\n<p> Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p></li><li>\n<p> Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p></li><li>\n<p> Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p></li></ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p><ul><li>  <code>&lt;simple-html&gt;</code> supports the following safe inline elements:<ul><li>  Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li><li>  Line breaks: <code>&lt;br&gt;</code>.</li><li>  Text grouping: <code>&lt;span&gt;</code>.</li><li>  Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>\nor points to certain permitted URIs such as the Help Center; see\n<a href="#uri-whitelisting">URI whitelisting</a>).<ul><li>  The <code>rel</code> attributes are permitted.</li><li>  The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li></ul></li></ul></li><li>  <code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:<ul><li>  Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li><li>  Paragraphs: <code>&lt;p&gt;</code>.</li></ul></li></ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p><ul><li>  Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li><li>  Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li></ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p><ul><li>  Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li><li>  More dangerous cases (such as setting the URL of an iframe) must still\nbe done using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at\nall.)</li></ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p><ol><li> Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li><li> Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular/Component-class.html">@Component</a>\'s\ndirective list.</li><li> For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li><li> In your template file, bind the message with either:<ul><li>  <code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span\n[innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li><li>  <code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li></ul></li><li> Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li><li> Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li><li> If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li></ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p><ul><li>  <strong>The message appears empty</strong><ul><li>  Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li></ul></li></ul>\n')),D.at("SimpleHtmlComponent",!1,"","simple-html","","angular_components/lib/simple_html/simple_html.dart",X.h('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p><ul><li>  <code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li><li>  <code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li></ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.b([D.j("Input","contents","","String",X.h("<p>HTML to display in the component.</p>\n"),"angular_components/lib/simple_html/simple_html.dart",!1,"")],x),H.b([D.j("Output","trigger","","Stream<UIEvent>",X.h("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),"angular_components/lib/simple_html/simple_html.dart",!1,"")],x))],[D.bW])
v=H.b([new R.a7(C.e6,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.a7(C.es,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],[R.a7])
y=new G.fB(R.ch(H.b([],[y]),v,x,P.e(y,y),!0))
this.x=y
this.r.k(0,y,this.a.e)
this.D(this.e)
return new D.A(this,0,this.e,this.x,[w])},
q:function(){this.r.j()},
v:function(){this.r.i()},
$aa:function(){return[G.fB]}}
var z=a.updateTypes([{func:1,ret:-1},{func:1,ret:[S.a,F.hN],args:[[S.a,,],P.k]},{func:1,ret:[S.a,F.hM],args:[[S.a,,],P.k]},{func:1,ret:[S.a,R.hO],args:[[S.a,,],P.k]},{func:1,ret:[S.a,S.iP],args:[[S.a,,],P.k]},{func:1,ret:[S.a,G.fB],args:[[S.a,,],P.k]}])
F.Qr.prototype={
$0:function(){var y,x,w,v
x=this.a
if(x.b==null)x.b=x.gHy(x)
x.d.E()
w=x.b
if(w==null)return
try{J.ana(w,this.b,x.e)}catch(v){y=H.aw(v)
if(y instanceof F.xz)$.a3n().k0(C.eW,"simple-html used untrusted URI: "+H.u(y),y,null)
else if(y instanceof F.wl)$.a3n().k0(C.eW,"simple-html used malformed element: "+H.u(y),y,null)
else throw v}x.a.dw(new F.Qq(x))},
$S:0}
F.Qq.prototype={
$0:function(){var y,x
y=this.a
x=W.ar
new H.ct(new W.kE(y.b.querySelectorAll("a.trigger"),[x]),new F.Qp(y),[x,[P.cK,W.an]]).aX(0,H.n2(y.d.gZK(),W.an))},
$S:0}
F.Qp.prototype={
$1:function(d){var y,x
y=J.amP(d)
x=this.a.c
return W.bS(y.a,y.b,x.giz(x),!1,H.f(y,0))},
$S:213}
F.Ql.prototype={
$1:function(d){var y,x
y=d.gd0(d).length===0||J.a3O(d.gd0(d),"/")
x="Whitelisted URIs with a path must end with a slash, which "+d.I(0)+" does not"
if(!y)H.H(P.cq(N.aqQ(x,null)))
return},
$S:214}
F.Qk.prototype={
$1:function(d){var y=this.a
return d.glL(d)===y.glL(y)&&J.i2(y.gd0(y),d.gd0(d))},
$S:215};(function installTearOffs(){var y=a._static_2,x=a._instance_0u
y(G,"aD4","aJO",1)
y(G,"aD3","aJN",2)
x(R.hO.prototype,"ga_a","a_b",0)
y(A,"aD2","aJQ",3)
y(F,"aD1","aJP",4)
y(E,"atd","aJM",5)})();(function inheritance(){var y=a.inheritMany
y(P.w,[F.Qo,F.x9,F.Qj,R.hO,S.iP,Y.JH,G.fB])
y(F.Qo,[F.hN,F.hM])
y(H.aS,[F.Qr,F.Qq,F.Qp,F.Ql,F.Qk])
y(P.f1,[F.xz,F.wl])
y(S.a,[G.Oc,G.Xw,G.Ob,G.Xv,A.Oe,A.Xy,F.Od,F.Xx,E.Oa,E.Xu])})();(function constants(){var y=a.makeConstList
C.c7=new Y.JH()
C.iv=new D.y("simple-html",G.aD4(),[F.hN])
C.e6=new D.y("simple-html-example",A.aD2(),[R.hO])
C.ee=new D.y("simple-html-api",E.atd(),[G.fB])
C.es=new D.y("simple-html-custom-whitelist-example",F.aD1(),[S.iP])
C.iU=new D.y("simple-html-block",G.aD3(),[F.hM])
C.cr=H.b(y([0,0,65498,45055,65535,34815,65534,18431]),[P.k])
C.lg=H.b(y(["clickCount","link","endLink"]),[P.c])
C.mp=new H.b7(3,{clickCount:"3",link:"<a>",endLink:"</a>"},C.lg,[P.c,null])
C.fe=H.b(y(["link","endLink"]),[P.c])
C.mw=new H.b7(2,{link:'<a href="https://example.com">',endLink:"</a>"},C.fe,[P.c,null])
C.cw=new H.b7(2,{link:"<a>",endLink:"</a>"},C.fe,[P.c,null])
C.lM=H.b(y(["bold","endBold","startList","endList","startListElement","endListElement"]),[P.c])
C.mA=new H.b7(6,{bold:"<b>",endBold:"</b>",startList:"<ul>",endList:"</ul>",startListElement:"<li>",endListElement:"</li>"},C.lM,[P.c,null])
C.lN=H.b(y(["bold","endBold","highlight","endHighlight"]),[P.c])
C.mB=new H.b7(4,{bold:"<b>",endBold:"</b>",highlight:"<span>",endHighlight:"</span>"},C.lN,[P.c,null])
C.aG=new S.et("simpleHtmlUriWhitelist",[[P.o,P.fE]])
C.ps=H.v(G.fB)
C.pt=H.v(F.hM)
C.pu=H.v(F.hN)
C.pv=H.v(R.hO)
C.q3=H.v(S.iP)})();(function staticFields(){$.a7m=null
$.a7l=null
$.a8j=!1
$.a7o=null
$.abF=!1
$.a7n=null
$.a8i=!1
$.a7j=null
$.a8h=!1})();(function lazyInitializers(){var y=a.lazy
y($,"aMl","a3t",function(){var x=P.fE
return P.m5(H.b([],[x]),x)})
y($,"aM5","a3n",function(){return N.tC("_SimpleHtmlBase")})
y($,"aQr","a3J",function(){return["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]})
y($,"aP7","akK",function(){return[$.a3J()]})
y($,"aP6","akJ",function(){return[$.a3J()]})
y($,"aQs","akQ",function(){return["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]})
y($,"aP8","akL",function(){return[$.akQ()]})})()}
$__dart_deferred_initializers__["z/RXY7u4dI4+1MCHMkuZSKGCxFg="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_69.part.js.map
