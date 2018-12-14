self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,d,e,f,g,h,i,j,k,l,m,n,$){var C,H,J,P={
a9G:function(o,p,q,a0){var y,x,w,v,u,t,s,r
y=p.length
if(y!==0){v=0
while(!0){if(!(v<y)){x=""
w=0
break}if(C.h.bM(p,v)===64){x=C.h.bo(p,0,v)
w=v+1
break}++v}if(w<y&&C.h.bM(p,w)===91){for(u=w;u<y;++u)if(C.h.bM(p,u)===93)break
if(u===y)throw H.m(P.bx("Invalid IPv6 host entry.",p,w))
P.a22(p,w+1,u);++u
if(u!==y&&C.h.bM(p,u)!==58)throw H.m(P.bx("Invalid end of authority",p,u))}else u=w
while(!0){if(!(u<y)){t=null
break}if(C.h.bM(p,u)===58){s=C.h.cR(p,u+1)
t=s.length!==0?P.eI(s,null,null):null
break}++u}r=C.h.bo(p,w,u)}else{x=""
r=null
t=null}return P.aqA(null,r,null,H.a(q.split("/"),[P.c]),t,null,a0,o,x)}},W,G={
ly:function(o,p){var y,x
y=new G.P4(P.e(P.c,null),o)
y.a=S.i(y,3,C.j,p,F.hU)
x=document.createElement("simple-html")
y.e=x
x=$.a9b
if(x==null){x=$.D
x=x.Y(null,C.o,$.$get$ald())
$.a9b=x}y.X(x)
return y},
aKg:function(o,p){var y=new G.Yj(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p,F.hU)
return y},
a99:function(o,p){var y,x
y=new G.P3(P.e(P.c,null),o)
y.a=S.i(y,3,C.j,p,F.hT)
x=document.createElement("simple-html-block")
y.e=x
x=$.a9a
if(x==null){x=$.D
x=x.Y(null,C.o,$.$get$alc())
$.a9a=x}y.X(x)
return y},
aKf:function(o,p){var y=new G.Yi(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p,F.hT)
return y},
aiH:function(){if($.aat)return
$.aat=!0
var y=$.$get$G()
y.w(0,C.oW,C.ie)
y.w(0,C.oV,C.iE)
E.z()
V.dB()},
P4:function P4(o,p){var _=this
_.a=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
Yj:function Yj(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
P3:function P3(o,p){var _=this
_.a=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
Yi:function Yi(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
fH:function fH(o){this.a=o}},Y={Kv:function Kv(){}},R={hV:function hV(o){this.a=o}},K,V,S={iS:function iS(){}},N,E={
apV:function(){return C.e7},
aKe:function(o,p){var y=new E.Yh(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p,G.fH)
return y},
aun:function(){if($.aar)return
$.aar=!0
$.$get$G().w(0,C.oU,C.e7)
E.z()
K.cM()
D.cz()
A.avJ()
F.awE()},
P2:function P2(o,p){var _=this
_.a=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
Yh:function Yh(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null}},M,B,Q,D,L,Z,A={
aKi:function(o,p){var y=new A.Yl(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p,R.hV)
return y},
avJ:function(){if($.adP)return
$.adP=!0
$.$get$G().w(0,C.oX,C.e_)
E.z()
G.aiH()},
P6:function P6(o,p){var _=this
_.a=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
Yl:function Yl(o,p){var _=this
_.a=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null}},U,T,O,X,F={
ls:function(o,p,q){var y=F.aa8(q==null?$.$get$a36():q)
return new F.hU(p,o,new P.l(null,null,0,[W.a0]),new R.B(!1,!1),new F.xn(y))},
a71:function(o,p,q){var y=F.aa8(q==null?$.$get$a36():q)
y.fT("p",null,null,null)
y.fT("ul",null,null,null)
y.fT("li",null,null,null)
return new F.hT(p,o,new P.l(null,null,0,[W.a0]),new R.B(!1,!1),new F.xn(y))},
a2V:function(o,p){return new F.xM(!1,null,null,"Unsafe URI "+H.u(o)+" because "+p)},
QH:function(o,p){return new F.wB(!1,null,null,"Element "+H.u(o)+" was malformed: "+p)},
aqx:function(o){var y=new F.Re(P.mb(o,P.fK))
y.Mi(o)
return y},
aa8:function(o){var y,x
y=new W.qa(H.a([],[W.hN]))
x=[P.c]
y.fT("a",H.a(["class","href","rel","target"],x),null,F.aqx(o))
y.fT("b",null,null,null)
y.fT("br",null,null,null)
y.fT("em",null,null,null)
y.fT("i",null,null,null)
y.fT("span",H.a(["class"],x),null,null)
y.fT("strong",null,null,null)
return y},
hU:function hU(o,p,q,r,s){var _=this
_.f=o
_.a=p
_.b=null
_.c=q
_.d=r
_.e=s},
hT:function hT(o,p,q,r,s){var _=this
_.f=o
_.a=p
_.b=null
_.c=q
_.d=r
_.e=s},
Ri:function Ri(){},
Rl:function Rl(o,p){this.a=o
this.b=p},
Rk:function Rk(o){this.a=o},
Rj:function Rj(o){this.a=o},
xM:function xM(o,p,q,r){var _=this
_.a=o
_.b=p
_.c=q
_.d=r},
wB:function wB(o,p,q,r){var _=this
_.a=o
_.b=p
_.c=q
_.d=r},
xn:function xn(o){this.a=o},
Re:function Re(o){this.a=o},
Rg:function Rg(){},
Rf:function Rf(o){this.a=o},
aKh:function(o,p){var y=new F.Yk(P.e(P.c,null),o)
y.a=S.i(y,3,C.k,p,S.iS)
return y},
awE:function(){if($.aas)return
$.aas=!0
$.$get$G().w(0,C.pv,C.el)
E.z()
G.aiH()},
P5:function P5(o,p){var _=this
_.a=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null},
Yk:function Yk(o,p){var _=this
_.a=_.y=_.x=_.r=null
_.b=o
_.c=p
_.f=_.e=_.d=null}}
h([P,G,Y,R,S,E,A,F])
C=n[0]
H=n[1]
J=n[2]
P=i(n[3],P)
W=n[4]
G=i(n[5],G)
Y=i(n[6],Y)
R=i(n[7],R)
K=n[8]
V=n[9]
S=i(n[10],S)
N=n[11]
E=i(n[12],E)
M=n[13]
B=n[14]
Q=n[15]
D=n[16]
L=n[17]
Z=n[18]
A=i(n[19],A)
U=n[20]
T=n[21]
O=n[22]
X=n[23]
F=i(n[24],F)
F.hU.prototype={
gJG:function(o){var y,x
y=this.f
x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.oi(y,x)
y=y.gdK(y)}return y}}
F.hT.prototype={
gJG:function(o){var y,x
y=this.f
x=y.children
if(y.firstElementChild==null)y=null
else{y=new W.oi(y,x)
y=y.gdK(y)}return y}}
F.Ri.prototype={
shv:function(o){return this.a.cQ(new F.Rl(this,o))},
gmN:function(){var y=this.c
return new P.n(y,[H.f(y,0)])}}
F.xM.prototype={}
F.wB.prototype={}
F.xn.prototype={
fU:function(o){if(!this.a.fU(o))throw H.m(F.QH(o,"prohibited element"))
return!0},
fp:function(o,p,q){var y
if(o.tagName.toLowerCase()==="a"&&p==="target"){if(!o.hasAttribute("rel"))throw H.m(F.QH(o,"did not set rel attribute"))
y=o.getAttribute("rel")
if(!C.e.aP(H.a(y.split(" "),[P.c]),"noopener"))throw H.m(F.QH(o,"did not set link type noopener (only "+y+")"))}if(!this.a.fp(o,p,q))throw H.m(F.QH(o,"prohibited attribute "+p+" with value "+H.u(q)))
return!0},
$ishN:1}
F.Re.prototype={
Mi:function(o){C.e.b1(this.a,new F.Rg())},
p9:function(o){var y,x,w,v,u,t
y=null
try{y=P.a21(o,0,null)}catch(v){H.av(v)
u=F.a2V(o,"Could not parse")
throw H.m(u)}x=P.a7j().q3(y)
w=null
try{w=J.any(x)}catch(v){H.av(v)
u=F.a2V(o,"Resolved URI "+H.u(x)+" had no origin")
throw H.m(u)}u=w
t=P.a7j()
if(!J.X(u,t.gmB(t))&&!this.WA(x))throw H.m(F.a2V(o,"Different origin and non-whitelisted URL"))
return!0},
WA:function(o){return C.e.eE(this.a,new F.Rf(o))}}
G.P4.prototype={
p:function(){var y=this.Z(this.e)
this.m(S.dd(document,y))
this.M(C.a,null)},
$asb:function(){return[F.hU]}}
G.Yj.prototype={
p:function(){var y=G.ly(this,0)
this.r=y
this.e=y.e
y=F.ls(this.n(C.b,this.a.Q),this.e,this.l(C.aI,this.a.Q,null))
this.x=y
this.r.k(0,y,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[F.hU])},
q:function(){this.r.j()},
v:function(){this.r.i()
this.x.d.F()},
$asb:function(){return[F.hU]}}
G.P3.prototype={
p:function(){var y=this.Z(this.e)
this.h(S.r(document,y))
this.M(C.a,null)},
$asb:function(){return[F.hT]}}
G.Yi.prototype={
p:function(){var y=G.a99(this,0)
this.r=y
this.e=y.e
y=F.a71(this.n(C.b,this.a.Q),this.e,this.l(C.aI,this.a.Q,null))
this.x=y
this.r.k(0,y,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[F.hT])},
q:function(){this.r.j()},
v:function(){this.r.i()
this.x.d.F()},
$asb:function(){return[F.hT]}}
R.hV.prototype={
a2B:function(){return this.a++}}
A.P6.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o,a0,a1,a2,a3,a4,a5
y=this.Z(this.e)
x=document
w=S.d(x,"h2",y)
this.m(w)
w.appendChild(x.createTextNode("SimpleHTML with default URI whitelist"))
v=S.d(x,"p",y)
this.m(v)
u=G.ly(this,3)
this.r=u
t=u.e
v.appendChild(t)
this.h(t)
u=this.c
s=F.ls(u.n(C.b,this.a.Q),t,u.l(C.aI,this.a.Q,null))
this.x=s
this.r.k(0,s,[])
r=S.d(x,"ul",y)
this.h(r)
q=S.d(x,"li",r)
this.m(q)
s=G.ly(this,6)
this.y=s
p=s.e
q.appendChild(p)
this.h(p)
s=F.ls(u.n(C.b,this.a.Q),p,u.l(C.aI,this.a.Q,null))
this.z=s
this.y.k(0,s,[])
o=S.d(x,"li",r)
this.m(o)
s=G.ly(this,8)
this.Q=s
a0=s.e
o.appendChild(a0)
this.h(a0)
s=F.ls(u.n(C.b,this.a.Q),a0,u.l(C.aI,this.a.Q,null))
this.ch=s
this.Q.k(0,s,[])
a1=S.d(x,"p",y)
this.m(a1)
a1.appendChild(x.createTextNode("The following message is removed due to disallowed HTML: ["))
s=G.ly(this,11)
this.cx=s
a2=s.e
a1.appendChild(a2)
this.h(a2)
s=F.ls(u.n(C.b,this.a.Q),a2,u.l(C.aI,this.a.Q,null))
this.cy=s
this.cx.k(0,s,[])
a1.appendChild(x.createTextNode("]"))
a3=S.d(x,"p",y)
this.m(a3)
s=G.ly(this,14)
this.db=s
a4=s.e
a3.appendChild(a4)
a4.className="click-target"
this.h(a4)
s=F.ls(u.n(C.b,this.a.Q),a4,u.l(C.aI,this.a.Q,null))
this.dx=s
this.db.k(0,s,[])
s=G.a99(this,15)
this.dy=s
a5=s.e
y.appendChild(a5)
this.h(a5)
u=F.a71(u.n(C.b,this.a.Q),a5,u.l(C.aI,this.a.Q,null))
this.fr=u
this.dy.k(0,u,[])
u=this.dx.c
this.M(C.a,[new P.n(u,[H.f(u,0)]).B(this.a7(this.f.ga2A(),W.a0))])},
q:function(){var y,x,w,v,u,t,s,r,q
y=this.f
y.toString
x=$.$get$b6().c_('I <b>love</b> using <span class="highlight">HTML</span>.',null,"SimpleHtmlExampleMessages_messageWithFormatting",["<b>","</b>",'<span class="highlight">',"</span>"],null)
w=this.fx
if(w!=x){this.x.shv(x)
this.fx=x}v=$.$get$b6().c_('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',null,"SimpleHtmlExampleMessages_messageLink",['<a href="localpage.html?param=1#test_fragment">',"</a>"],null)
w=this.fy
if(w!=v){this.z.shv(v)
this.fy=v}u=$.$get$b6().c_('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',null,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],null)
w=this.go
if(w!=u){this.ch.shv(u)
this.go=u}t=$.$get$b6().c_('Please consult my <a href="https://hecuba.org">suspicious website</a>.',null,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",['<a href="https://hecuba.org">',"</a>"],null)
w=this.id
if(w!=t){this.cy.shv(t)
this.id=t}w=y.a
s='You <a class="trigger">clicked here</a> '+w+" times."
r=$.$get$b6().c_(s,null,"SimpleHtmlExampleMessages_messageWithClickHandler",[w,'<a class="trigger">',"</a>"],null)
w=this.k1
if(w!=r){this.dx.shv(r)
this.k1=r}q=$.$get$b6().c_("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",null,"SimpleHtmlExampleMessages_blockMessage",["<b>","</b>","<ul>","</ul>","<li>","</li>"],null)
w=this.k2
if(w!=q){this.fr.shv(q)
this.k2=q}this.r.j()
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
this.x.d.F()
this.z.d.F()
this.ch.d.F()
this.cy.d.F()
this.dx.d.F()
this.fr.d.F()},
$asb:function(){return[R.hV]}}
A.Yl.prototype={
p:function(){var y,x,w
y=new A.P6(P.e(P.c,null),this)
x=R.hV
y.a=S.i(y,3,C.j,0,x)
w=document.createElement("simple-html-example")
y.e=w
w=$.a9d
if(w==null){w=$.D
w=w.Y(null,C.o,$.$get$ale())
$.a9d=w}y.X(w)
this.r=y
this.e=y.e
w=new R.hV(0)
this.x=w
y.k(0,w,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[x])},
q:function(){this.r.j()},
v:function(){this.r.i()},
$asb:function(){return[R.hV]}}
S.iS.prototype={}
F.P5.prototype={
p:function(){var y,x,w,v,u,t,s,r,q,p,o
y=this.Z(this.e)
x=document
S.d(x,"h2",y).appendChild(x.createTextNode("SimpleHTML with a custom URI whitelist"))
w=S.d(x,"ul",y)
v=S.d(x,"li",w)
u=G.ly(this,4)
this.r=u
t=u.e
v.appendChild(t)
u=this.c
s=F.ls(u.n(C.b,this.a.Q),t,u.l(C.aI,this.a.Q,null))
this.x=s
this.r.k(0,s,[])
r=S.d(x,"li",w)
s=G.ly(this,6)
this.y=s
q=s.e
r.appendChild(q)
s=F.ls(u.n(C.b,this.a.Q),q,u.l(C.aI,this.a.Q,null))
this.z=s
this.y.k(0,s,[])
r.appendChild(x.createTextNode("(removed)"))
p=S.d(x,"li",w)
s=G.ly(this,9)
this.Q=s
o=s.e
p.appendChild(o)
u=F.ls(u.n(C.b,this.a.Q),o,u.l(C.aI,this.a.Q,null))
this.ch=u
this.Q.k(0,u,[])
p.appendChild(x.createTextNode("(removed)"))
this.M(C.a,null)},
q:function(){var y,x,w,v
this.f.toString
y=C.c4.t2('<a href="'+H.u(P.os(C.cn,"https://wordpress.org/plugins/amp/",C.aL,!1))+'">',"</a>")
x=this.cx
if(x!=y){this.x.shv(y)
this.cx=y}w=C.c4.t2('<a href="'+H.u(P.os(C.cn,"https://wordpress.org/plugins/malware/",C.aL,!1))+'">',"</a>")
x=this.cy
if(x!=w){this.z.shv(w)
this.cy=w}v=C.c4.t2('<a href="'+H.u(P.os(C.cn,"javascript:alert('!')",C.aL,!1))+'">',"</a>")
x=this.db
if(x!=v){this.ch.shv(v)
this.db=v}this.r.j()
this.y.j()
this.Q.j()},
v:function(){this.r.i()
this.y.i()
this.Q.i()
this.x.d.F()
this.z.d.F()
this.ch.d.F()},
$asb:function(){return[S.iS]}}
F.Yk.prototype={
p:function(){var y,x,w
y=new F.P5(P.e(P.c,null),this)
x=S.iS
y.a=S.i(y,3,C.j,0,x)
w=document.createElement("simple-html-custom-whitelist-example")
y.e=w
w=$.a9c
if(w==null){w=$.D
w=w.Y(null,C.W,C.a)
$.a9c=w}y.X(w)
this.r=y
this.e=y.e
w=new S.iS()
this.x=w
y.k(0,w,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[x])},
N:function(o,p,q){var y
if(o===C.aI&&0===p){y=this.y
if(y==null){y=P.fK
y=P.mb(H.a([P.a9G("https","developers.google.com","",null),P.a9G("https","wordpress.org","plugins/amp/",null)],[y]),y)
this.y=y}return y}return q},
q:function(){this.r.j()},
v:function(){this.r.i()},
$asb:function(){return[S.iS]}}
Y.Kv.prototype={
t2:function(o,p){var y="Visit "+o+"this site"+o+"!"
return $.$get$b6().c_(y,null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",[o,p],null)}}
G.fH.prototype={
gaB:function(){return this.a}}
E.P2.prototype={
gnd:function(){var y=this.y
if(y==null){y=document
this.y=y}return y},
gyN:function(){var y=this.z
if(y==null){y=window
this.z=y}return y},
gne:function(){var y=this.Q
if(y==null){y=this.c
y=T.aY(y.l(C.b,this.a.Q,null),y.l(C.C,this.a.Q,null),y.n(C.f,this.a.Q),this.gyN())
this.Q=y}return y},
gyz:function(){var y,x
y=this.ch
if(y==null){y=this.c.n(C.S,this.a.Q)
x=this.gne()
y=new O.aC(y,x)
this.ch=y}return y},
gqF:function(){var y=this.cx
if(y==null){y=new K.aH(this.gnd(),this.gne(),P.aU(null,[P.q,P.c]))
this.cx=y}return y},
gM3:function(){var y=this.cy
if(y==null){y=T.b1(this.c.n(C.f,this.a.Q))
this.cy=y}return y},
guJ:function(){var y=this.db
if(y==null){y=G.b5(this.c.l(C.v,this.a.Q,null))
this.db=y}return y},
gF0:function(){var y=this.dx
if(y==null){y=G.b9(this.gnd(),this.c.l(C.w,this.a.Q,null))
this.dx=y}return y},
gF1:function(){var y=this.dy
if(y==null){y=G.b0(this.guJ(),this.gF0(),this.c.l(C.u,this.a.Q,null))
this.dy=y}return y},
guK:function(){var y=this.fr
if(y==null){this.fr=!0
y=!0}return y},
gF2:function(){var y=this.fx
if(y==null){this.fx=!0
y=!0}return y},
gyF:function(){var y=this.fy
if(y==null){y=this.gnd()
y=new R.aE(y.querySelector("head"),!1,y)
this.fy=y}return y},
gyO:function(){var y=this.go
if(y==null){y=X.b3()
this.go=y}return y},
gyE:function(){var y=this.id
if(y==null){y=K.b2(this.gyF(),this.gF1(),this.guJ(),this.gqF(),this.gne(),this.gyz(),this.guK(),this.gF2(),this.gyO())
this.id=y}return y},
gMc:function(){var y,x,w,v
y=this.k1
if(y==null){y=this.c
x=y.n(C.f,this.a.Q)
w=this.guK()
v=this.gyE()
y.l(C.m,this.a.Q,null)
y=new X.aB(w,x,v)
this.k1=y}return y},
p:function(){var y,x
y=this.Z(this.e)
x=K.cj(this,0)
this.r=x
y.appendChild(x.e)
x=this.c.n(C.a5,this.a.Q)
x=new X.a6(x,!J.bs(window.location.href,"enableLatencyCharts=false"))
this.x=x
this.r.k(0,x,[])
this.M(C.a,null)},
N:function(o,p,q){var y
if(o===C.M&&0===p)return this.gnd()
if(o===C.H&&0===p)return this.gyN()
if(o===C.b&&0===p)return this.gne()
if(o===C.O&&0===p)return this.gyz()
if(o===C.N&&0===p)return this.gqF()
if(o===C.T&&0===p)return this.gM3()
if(o===C.v&&0===p)return this.guJ()
if(o===C.w&&0===p)return this.gF0()
if(o===C.u&&0===p)return this.gF1()
if(o===C.R&&0===p)return this.guK()
if(o===C.F&&0===p)return this.gF2()
if(o===C.Q&&0===p)return this.gyF()
if(o===C.E&&0===p)return this.gyO()
if(o===C.P&&0===p)return this.gyE()
if(o===C.m&&0===p)return this.gMc()
if(o===C.G&&0===p){y=this.k2
if(y==null){this.k2=C.y
y=C.y}return y}if(o===C.x&&0===p){y=this.k3
if(y==null){y=new K.aL(this.gqF())
this.k3=y}return y}return q},
q:function(){var y,x
y=this.f.a
x=this.k4
if(x!==y){this.x.a=y
this.k4=y}this.r.j()},
v:function(){this.r.i()},
$asb:function(){return[G.fH]}}
E.Yh.prototype={
p:function(){var y,x,w,v
y=P.c
x=new E.P2(P.e(y,null),this)
w=G.fH
x.a=S.i(x,3,C.j,0,w)
v=document.createElement("simple-html-api")
x.e=v
v=$.a98
if(v==null){v=$.D
v=v.Y(null,C.W,C.a)
$.a98=v}x.X(v)
this.r=x
this.e=x.e
x=[R.j]
x=H.a([new R.a2("README",!1,"","","","angular_components/lib/simple_html/README.md",X.h('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p><ul><li>  Light formatting (bold, italic, newlines).</li><li>  Links to external domains (with a customisable whitelist).</li><li>  Arbitrary click handlers on substrings within the text.</li></ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p><ul><li>  Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li><li>  Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li></ul>\n<p>The alternatives include:</p><ul><li>  Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.<ul><li>  This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li></ul></li><li>  Using the <code>[innerHtml]</code> directive with a string argument.<ul><li>  This is secure but very strict; only very limited tags are allowed.</li><li>  The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li><li>  The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li></ul></li><li>  Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.<ul><li>  This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li></ul></li></ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p><ol><li>\n<p> Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p></li><li>\n<p> Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p></li><li>\n<p> Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p></li><li>\n<p> Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p></li></ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p><ul><li>  <code>&lt;simple-html&gt;</code> supports the following safe inline elements:<ul><li>  Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li><li>  Line breaks: <code>&lt;br&gt;</code>.</li><li>  Text grouping: <code>&lt;span&gt;</code>, including the <code>class</code> attribute.</li><li>  Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>\nor points to certain permitted URIs such as the Help Center; see\n<a href="#uri-whitelisting">URI whitelisting</a>).<ul><li>  The <code>class</code> and <code>rel</code> attributes are permitted.</li><li>  The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li></ul></li></ul></li><li>  <code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:<ul><li>  Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li><li>  Paragraphs: <code>&lt;p&gt;</code>.</li></ul></li></ul>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p><ul><li>  Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li><li>  Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li></ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p><ul><li>  Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li><li>  More dangerous cases (such as setting the URL of an iframe) must still\nbe done using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at\nall.)</li></ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p><ol><li> Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li><li> Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular/Component-class.html">@Component</a>\'s\ndirective list.</li><li> For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li><li> In your template file, bind the message with either:<ul><li>  <code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span\n[innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li><li>  <code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li></ul></li><li> Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li><li> Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li><li> If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li></ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p><ul><li>  <strong>The message appears empty</strong><ul><li>  Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li></ul></li></ul>\n'),H.a([],x),H.a([],x)),new R.a2("SimpleHtmlComponent",!1,"","simple-html","","angular_components/lib/simple_html/simple_html.dart",X.h('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p><ul><li>  <code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li><li>  <code>&lt;span&gt;</code> with (optionally) a class attribute.</li><li>  <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with no attributes.</li></ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([new R.j("Input","contents","","String",X.h("<p>HTML to display in the component.</p>\n"),"angular_components/lib/simple_html/simple_html.dart",!1,"")],x),H.a([new R.j("Output","trigger","","Stream<UIEvent>",X.h("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),"angular_components/lib/simple_html/simple_html.dart",!1,"")],x))],[R.a2])
v=H.a([new R.a7(C.e_,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.a7(C.el,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],[R.a7])
y=new G.fH(R.cp(H.a([],[y]),v,x,null,C.J,P.e(y,y),!0,C.J))
this.x=y
this.r.k(0,y,this.a.e)
this.E(this.e)
return new D.A(this,0,this.e,this.x,[w])},
q:function(){this.r.j()},
v:function(){this.r.i()},
$asb:function(){return[G.fH]}}
var z=j([{func:1,ret:-1},{func:1,ret:[S.b,F.hU],args:[[S.b,,],P.k]},{func:1,ret:[S.b,F.hT],args:[[S.b,,],P.k]},{func:1,ret:[S.b,R.hV],args:[[S.b,,],P.k]},{func:1,ret:[S.b,S.iS],args:[[S.b,,],P.k]},{func:1,ret:[S.b,G.fH],args:[[S.b,,],P.k]}])
F.Rl.prototype={
$0:function(){var y,x,w,v
x=this.a
if(x.b==null)x.b=x.gJG(x)
x.d.F()
w=x.b
if(w==null)return
try{J.anV(w,this.b,x.e)}catch(v){y=H.av(v)
if(y instanceof F.xM)$.$get$a2S().kG(C.eO,"simple-html used untrusted URI: "+H.u(y),y,null)
else if(y instanceof F.wB)$.$get$a2S().kG(C.eO,"simple-html used malformed element: "+H.u(y),y,null)
else throw v}x.a.dJ(new F.Rk(x))},
$S:0}
F.Rk.prototype={
$0:function(){var y,x
y=this.a
x=W.ap
new H.cF(new W.kD(y.b.querySelectorAll("a.trigger"),[x]),new F.Rj(y),[x,[P.cI,W.am]]).b1(0,H.n8(y.d.ga20(),W.am))},
$S:0}
F.Rj.prototype={
$1:function(o){var y,x
y=J.anw(o)
x=this.a.c
return W.bV(y.a,y.b,x.gj2(x),!1,H.f(y,0))},
"call*":"$1",
$R:1,
$S:218}
F.Rg.prototype={
$1:function(o){var y,x
y=o.gcD(o).length===0||J.a4H(o.gcD(o),"/")
x="Whitelisted URIs with a path must end with a slash, which "+o.J(0)+" does not"
if(!y)H.F(P.cm(N.arD(x,null)))
return},
$S:219}
F.Rf.prototype={
$1:function(o){var y=this.a
return o.gmB(o)===y.gmB(y)&&J.i6(y.gcD(y),o.gcD(o))},
$S:220};(function installTearOffs(){g(G,"aDG",1,0,0,null,["$2"],["aKg"],1,0)
g(G,"aDF",1,0,0,null,["$2"],["aKf"],2,0)
g(R.hV.prototype,"ga2A",0,0,0,null,["$0"],["a2B"],0,0)
g(A,"aDE",1,0,0,null,["$2"],["aKi"],3,0)
g(F,"aDD",1,0,0,null,["$2"],["aKh"],4,0)
g(E,"atR",1,0,0,null,["$2"],["aKe"],5,0)})();(function inheritance(){var y=b
y(P.t,[F.Ri,F.xn,F.Re,R.hV,S.iS,Y.Kv,G.fH])
y(F.Ri,[F.hU,F.hT])
y(H.aS,[F.Rl,F.Rk,F.Rj,F.Rg,F.Rf])
y(P.f8,[F.xM,F.wB])
y(S.b,[G.P4,G.Yj,G.P3,G.Yi,A.P6,A.Yl,F.P5,F.Yk,E.P2,E.Yh])})();(function constants(){C.c4=new Y.Kv()
C.ie=new D.y("simple-html",G.aDG(),[F.hU])
C.e_=new D.y("simple-html-example",A.aDE(),[R.hV])
C.e7=new D.y("simple-html-api",E.atR(),[G.fH])
C.el=new D.y("simple-html-custom-whitelist-example",F.aDD(),[S.iS])
C.iE=new D.y("simple-html-block",G.aDF(),[F.hT])
C.cn=H.a(e([0,0,65498,45055,65535,34815,65534,18431]),[P.k])
C.aI=new S.dV("simpleHtmlUriWhitelist",[[P.q,P.fK]])
C.oU=H.x(G.fH)
C.oV=H.x(F.hT)
C.oW=H.x(F.hU)
C.oX=H.x(R.hV)
C.pv=H.x(S.iS)})();(function staticFields(){$.a9b=null
$.a9a=null
$.aat=!1
$.a9d=null
$.adP=!1
$.a9c=null
$.aas=!1
$.a98=null
$.aar=!1})();(function lazyInitializers(){d($,"a36","$get$a36",function(){var y=P.fK
return P.mb(H.a([],[y]),y)})
d($,"a2S","$get$a2S",function(){return N.tI("_SimpleHtmlBase")})
d($,"a4A","$get$a4A",function(){return["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]})
d($,"ald","$get$ald",function(){return[$.$get$a4A()]})
d($,"alc","$get$alc",function(){return[$.$get$a4A()]})
d($,"alj","$get$alj",function(){return["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]})
d($,"ale","$get$ale",function(){return[$.$get$alj()]})})()}
$__dart_deferred_initializers__["64izWufoeq8LPZA14XBK7EXJNt8="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_67.part.js.map
