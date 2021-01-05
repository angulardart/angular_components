self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={
aa0:function(){throw H.p(P.aN("Cannot change an unmodifiable set"))},
Fu:function Fu(){},
wu:function wu(d,e){this.a=d
this.$ti=e},
yh:function yh(){},
aa6:function(d,e,f,g){var w,v,u,t,s,r,q,p,o,n,m,l=null,k=e.length
if(k!==0){u=0
while(!0){if(!(u<k)){w=""
v=0
break}if(C.d.by(e,u)===64){w=C.d.b0(e,0,u)
v=u+1
break}++u}if(v<k&&C.d.by(e,v)===91){for(t=v,s=-1;t<k;++t){r=C.d.by(e,t)
if(r===37&&s<0){q=C.d.dz(e,"25",t+1)?t+2:t
s=t
t=q}else if(r===93)break}if(t===k)throw H.p(P.cn("Invalid IPv6 host entry.",e,v))
p=s<0?t:s
P.a2C(e,v+1,p);++t
if(t!==k&&C.d.by(e,t)!==58)throw H.p(P.cn("Invalid end of authority",e,t))}else t=v
while(!0){if(!(t<k)){o=l
break}if(C.d.by(e,t)===58){n=C.d.cz(e,t+1)
o=n.length!==0?P.fh(n,l):l
break}++t}m=C.d.b0(e,v,t)}else{o=l
m=o
w=""}return P.ar4(m,l,H.a(f.split("/"),x.S),o,g,d,w)}},W,G={
mA:function(d,e){var w,v=new G.Dm(E.S(d,e,1)),u=$.a9w
if(u==null)u=$.a9w=O.a0($.aEW,null)
v.b=u
w=document.createElement("simple-html")
v.c=w
return v},
aMU:function(){return new G.KD(new G.R())},
a9u:function(d,e){var w,v=new G.Dl(E.S(d,e,1)),u=$.a9v
if(u==null)u=$.a9v=O.a0($.aEV,null)
v.b=u
w=document.createElement("simple-html-block")
v.c=w
return v},
aMT:function(){return new G.KC(new G.R())},
aj2:function(){if($.aaM)return
$.aaM=!0
$.T.w(0,C.n8,new D.l("simple-html",G.aCM(),x.x))
$.T.w(0,C.n7,new D.l("simple-html-block",G.aCL(),x.X))
E.F()
V.dM()},
Dm:function Dm(d){var _=this
_.c=_.b=_.a=null
_.d=d},
KD:function KD(d){var _=this
_.c=_.b=_.a=null
_.d=d},
Dl:function Dl(d){var _=this
_.c=_.b=_.a=null
_.d=d},
KC:function KC(d){var _=this
_.c=_.b=_.a=null
_.d=d},
hU:function hU(d){this.a=d}},Y={Ul:function Ul(){}},R={k_:function k_(){this.a=0}},K,V,E={
aq7:function(){return C.hi},
aMS:function(){return new E.KB(new G.R())},
avb:function(){if($.aaK)return
$.aaK=!0
$.T.w(0,C.n6,new D.l("simple-html-api",E.ahM(),x.V))
E.F()
K.d7()
D.cV()
A.awx()
F.axu()},
Dk:function Dk(d){var _=this
_.c=_.b=_.a=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KB:function KB(d){var _=this
_.c=_.b=_.a=null
_.d=d}},M,Q,D,Z,O,A={
aMW:function(){return new A.KF(new G.R())},
awx:function(){if($.acU)return
$.acU=!0
$.T.w(0,C.n9,new D.l("simple-html-example",A.akX(),x.s))
E.F()
G.aj2()},
Do:function Do(d){var _=this
_.c=_.b=_.a=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KF:function KF(d){var _=this
_.c=_.b=_.a=null
_.d=d}},T,L,N,U,X,B,S={lK:function lK(){}},F={
mv:function(d,e,f,g){var w=f==null?$.a4G():f
w=F.aay(w,E.i2(g,!1))
return new F.lJ(e,d,new P.N(null,null,x.K),new R.aM(!1),new F.we(w))},
a6f:function(d,e,f,g){var w,v=f==null?$.a4G():f
v=F.aay(v,E.i2(g,!1))
w=x.i
v.h5("p",H.a(["class"],w))
v.h5("ul",H.a(["class"],w))
v.h5("li",H.a(["class"],w))
return new F.lI(e,d,new P.N(null,null,x.K),new R.aM(!1),new F.we(v))},
YA:function(d,e){return new F.wv(!1,null,null,"Unsafe URI "+H.B(d)+" because "+e)},
XS:function(d,e){return new F.vJ(!1,null,null,"Element "+H.B(d)+" was malformed: "+e)},
aaA:function(d){var w,v,u=null
try{u=P.a2B(d)}catch(w){H.bb(w)
v=F.YA(d,"Could not parse")
throw H.p(v)}return P.a6p().p2(u)},
aqT:function(d){var w=new F.Ye(P.nL(d,x.k))
w.Kl(d)
return w},
aay:function(d,e){var w=e?new F.Xu():F.aqT(d),v=new W.pW(H.a([],x.Q)),u=x.i
v.Fl("a",H.a(["class","href","rel","target","title"],u),w)
v.h5("b",H.a(["class"],u))
v.h5("br",H.a(["class"],u))
v.h5("em",H.a(["class"],u))
v.h5("i",H.a(["class"],u))
v.h5("span",H.a(["class"],u))
v.h5("strong",H.a(["class"],u))
return v},
lJ:function lJ(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
lI:function lI(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
Yh:function Yh(){},
Yk:function Yk(d,e){this.a=d
this.b=e},
Yj:function Yj(d){this.a=d},
Yi:function Yi(d){this.a=d},
wv:function wv(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
vJ:function vJ(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
we:function we(d){this.a=d},
Ye:function Ye(d){this.a=d},
Yg:function Yg(){},
Yf:function Yf(d){this.a=d},
Xu:function Xu(){},
aMV:function(){return new F.KE(new G.R())},
axu:function(){if($.aaL)return
$.aaL=!0
$.T.w(0,C.nJ,new D.l("simple-html-custom-whitelist-example",F.akW(),x.y))
E.F()
G.aj2()},
Dn:function Dn(d){var _=this
_.c=_.b=_.a=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KE:function KE(d){var _=this
_.c=_.b=_.a=_.e=null
_.d=d}}
a.setFunctionNamesIfNecessary([P,G,Y,R,E,A,S,F])
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
E=a.updateHolder(c[10],E)
M=c[11]
Q=c[12]
D=c[13]
Z=c[14]
O=c[15]
A=a.updateHolder(c[16],A)
T=c[17]
L=c[18]
N=c[19]
U=c[20]
X=c[21]
B=c[22]
S=a.updateHolder(c[23],S)
F=a.updateHolder(c[24],F)
P.Fu.prototype={
R:function(d,e){P.aa0()
return H.lC(y.c)},
bC:function(d,e){P.aa0()
return H.lC(y.c)}}
P.wu.prototype={
aP:function(d,e){return J.a1M(this.a,e)},
gbb:function(d){return J.bG(J.a1P(this.a))},
gM:function(d){return J.bR(this.a)}}
P.yh.prototype={}
F.lJ.prototype={
gI2:function(d){var w=this.f,v=w.children
if(w.firstElementChild==null)w=null
else{w=new W.oc(w,v)
w=w.gdw(w)}return w}}
F.lI.prototype={
gI2:function(d){var w=this.f,v=w.children
if(w.firstElementChild==null)w=null
else{w=new W.oc(w,v)
w=w.gdw(w)}return w}}
F.Yh.prototype={
sh6:function(d){this.a.cL(new F.Yk(this,d))}}
F.wv.prototype={}
F.vJ.prototype={}
F.we.prototype={
fu:function(d){if(!this.a.fu(d))throw H.p(F.XS(d,"prohibited element"))
return!0},
fg:function(d,e,f){var w,v
if(d.tagName.toLowerCase()==="a"&&e==="target"){w=d.hasAttribute("rel")
if(!w)throw H.p(F.XS(d,"did not set rel attribute"))
v=d.getAttribute("rel")
if(!C.e.aP(H.a(v.split(" "),x.S),"noopener"))throw H.p(F.XS(d,"did not set link type noopener (only "+v+")"))}if(!this.a.fg(d,e,f))throw H.p(F.XS(d,"prohibited attribute "+e+" with value "+H.B(f)))
return!0},
$ifr:1}
F.Ye.prototype={
Kl:function(d){C.e.b2(this.a,new F.Yg())},
lc:function(d){var w,v,u,t=F.aaA(d),s=null
try{s=J.and(t)}catch(w){H.bb(w)
v=F.YA(d,"Resolved URI "+H.B(t)+" had no origin")
throw H.p(v)}v=s
u=P.a6p()
if(!J.aa(v,u.glN(u))&&!this.NU(t))throw H.p(F.YA(d,"Different origin and non-whitelisted URL"))
return!0},
NU:function(d){return C.e.cM(this.a,new F.Yf(d))}}
F.Xu.prototype={
lc:function(d){var w=F.aaA(d)
if(!J.a1M(C.kx.a,w.ghx()))throw H.p(F.YA(d,"URI scheme "+w.ghx()+" not allowed"))
return!0}}
G.Dm.prototype={
q:function(){var w=this.a2()
this.m(T.dJ(document,w))}}
G.KD.prototype={
q:function(){var w,v=this,u=G.mA(v,0)
v.b=u
w=u.c
u=F.mv(v.n(C.b,null),w,v.l(C.aF,null),null)
v.a=u
v.F(w)},
A:function(){this.b.j()},
G:function(){this.a.d.H()}}
G.Dl.prototype={
q:function(){var w=this.a2()
this.h(T.u(document,w))}}
G.KC.prototype={
q:function(){var w,v=this,u=G.a9u(v,0)
v.b=u
w=u.c
u=F.a6f(v.n(C.b,null),w,v.l(C.aF,null),null)
v.a=u
v.F(w)},
A:function(){this.b.j()},
G:function(){this.a.d.H()}}
R.k_.prototype={
Zw:function(){return this.a++}}
A.Do.prototype={
q:function(){var w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=h.a,e=h.a2(),d=document,a0=T.d(d,e,"h2")
h.m(a0)
T.b(a0,"SimpleHTML with default URI whitelist")
w=T.d(d,e,"p")
h.m(w)
v=G.mA(h,3)
h.e=v
u=v.c
w.appendChild(u)
h.h(u)
v=h.d
t=v.a
v=v.b
s=F.mv(t.n(C.b,v),u,t.l(C.aF,v),g)
h.f=s
h.e.K(0,s)
r=T.d(d,e,"ul")
h.h(r)
q=T.d(d,r,"li")
h.m(q)
s=G.mA(h,6)
h.r=s
p=s.c
q.appendChild(p)
h.h(p)
s=F.mv(t.n(C.b,v),p,t.l(C.aF,v),g)
h.x=s
h.r.K(0,s)
o=T.d(d,r,"li")
h.m(o)
s=G.mA(h,8)
h.y=s
n=s.c
o.appendChild(n)
h.h(n)
s=F.mv(t.n(C.b,v),n,t.l(C.aF,v),g)
h.z=s
h.y.K(0,s)
m=T.d(d,e,"p")
h.m(m)
T.b(m,"The following message is removed due to disallowed HTML: [")
s=G.mA(h,11)
h.Q=s
l=s.c
m.appendChild(l)
h.h(l)
s=F.mv(t.n(C.b,v),l,t.l(C.aF,v),g)
h.ch=s
h.Q.K(0,s)
T.b(m,"]")
k=T.d(d,e,"p")
h.m(k)
s=G.mA(h,14)
h.cx=s
j=s.c
k.appendChild(j)
h.O(j,"click-target")
h.h(j)
s=F.mv(t.n(C.b,v),j,t.l(C.aF,v),g)
h.cy=s
h.cx.K(0,s)
s=G.a9u(h,15)
h.db=s
i=s.c
e.appendChild(i)
h.h(i)
v=F.a6f(t.n(C.b,v),i,t.l(C.aF,v),g)
h.dx=v
h.db.K(0,v)
v=h.cy.c
h.bo(H.a([new P.e(v,H.m(v).i("e<1>")).D(h.ad(f.gZv(),x.p))],x.a))},
A:function(){var w,v,u,t,s,r,q,p,o,n=this,m=null,l=n.a
l.toString
w=x.M
v=T.aQ('I <b>love</b> using <span class="highlight">HTML</span>.',m,"SimpleHtmlExampleMessages_messageWithFormatting",H.a(["<b>","</b>",'<span class="highlight">',"</span>"],w),m)
u=n.dy
if(u!=v){n.f.sh6(v)
n.dy=v
t=!0}else t=!1
if(t)n.e.d.st(1)
s=T.aQ('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',m,"SimpleHtmlExampleMessages_messageLink",H.a(['<a href="localpage.html?param=1#test_fragment">',"</a>"],w),m)
u=n.fr
if(u!=s){n.x.sh6(s)
n.fr=s
t=!0}else t=!1
if(t)n.r.d.st(1)
r=T.aQ('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',m,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",H.a(['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],w),m)
u=n.fx
if(u!=r){n.z.sh6(r)
n.fx=r
t=!0}else t=!1
if(t)n.y.d.st(1)
q=T.aQ('Please consult my <a href="https://hecuba.org">suspicious website</a>.',m,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",H.a(['<a href="https://hecuba.org">',"</a>"],w),m)
u=n.fy
if(u!=q){n.ch.sh6(q)
n.fy=q
t=!0}else t=!1
if(t)n.Q.d.st(1)
u=l.a
p=T.aQ('You <a class="trigger">clicked here</a> '+u+" times.",m,"SimpleHtmlExampleMessages_messageWithClickHandler",H.a([u,'<a class="trigger">',"</a>"],w),m)
u=n.go
if(u!=p){n.cy.sh6(p)
n.go=p
t=!0}else t=!1
if(t)n.cx.d.st(1)
o=T.aQ("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",m,"SimpleHtmlExampleMessages_blockMessage",H.a(["<b>","</b>","<ul>","</ul>","<li>","</li>"],w),m)
w=n.id
if(w!=o){n.dx.sh6(o)
n.id=o
t=!0}else t=!1
if(t)n.db.d.st(1)
n.e.j()
n.r.j()
n.y.j()
n.Q.j()
n.cx.j()
n.db.j()},
G:function(){var w=this
w.e.k()
w.r.k()
w.y.k()
w.Q.k()
w.cx.k()
w.db.k()
w.f.d.H()
w.x.d.H()
w.z.d.H()
w.ch.d.H()
w.cy.d.H()
w.dx.d.H()}}
A.KF.prototype={
q:function(){var w,v=this,u=new A.Do(E.S(v,0,3)),t=$.a9y
if(t==null)t=$.a9y=O.a0($.aEX,null)
u.b=t
w=document.createElement("simple-html-example")
u.c=w
v.b=u
v.a=new R.k_()
v.F(w)}}
S.lK.prototype={}
F.Dn.prototype={
q:function(){var w,v,u,t,s,r,q,p,o,n,m=this,l="(removed)",k=m.a2(),j=document
T.b(T.d(j,k,"h2"),"SimpleHTML with a custom URI whitelist")
w=T.d(j,k,"ul")
v=T.d(j,w,"li")
u=G.mA(m,4)
m.e=u
t=u.c
v.appendChild(t)
u=m.d
s=u.a
u=u.b
r=F.mv(s.n(C.b,u),t,s.l(C.aF,u),null)
m.f=r
m.e.K(0,r)
q=T.d(j,w,"li")
r=G.mA(m,6)
m.r=r
p=r.c
q.appendChild(p)
r=F.mv(s.n(C.b,u),p,s.l(C.aF,u),null)
m.x=r
m.r.K(0,r)
T.b(q,l)
o=T.d(j,w,"li")
r=G.mA(m,9)
m.y=r
n=r.c
o.appendChild(n)
u=F.mv(s.n(C.b,u),n,s.l(C.aF,u),null)
m.z=u
m.y.K(0,u)
T.b(o,l)},
A:function(){var w,v,u,t,s,r=this,q="</a>"
r.a.toString
w=C.c6.qT('<a href="'+H.B(P.qS(C.cn,"https://wordpress.org/plugins/amp/",C.aI,!1))+'">',q)
v=r.Q
if(v!=w){r.f.sh6(w)
r.Q=w
u=!0}else u=!1
if(u)r.e.d.st(1)
t=C.c6.qT('<a href="'+H.B(P.qS(C.cn,"https://wordpress.org/plugins/malware/",C.aI,!1))+'">',q)
v=r.ch
if(v!=t){r.x.sh6(t)
r.ch=t
u=!0}else u=!1
if(u)r.r.d.st(1)
s=C.c6.qT('<a href="'+H.B(P.qS(C.cn,"javascript:alert('!')",C.aI,!1))+'">',q)
v=r.cx
if(v!=s){r.z.sh6(s)
r.cx=s
u=!0}else u=!1
if(u)r.y.d.st(1)
r.e.j()
r.r.j()
r.y.j()},
G:function(){var w=this
w.e.k()
w.r.k()
w.y.k()
w.f.d.H()
w.x.d.H()
w.z.d.H()}}
F.KE.prototype={
q:function(){var w,v=this,u=new F.Dn(E.S(v,0,3)),t=$.a9x
if(t==null)t=$.a9x=O.bH(C.a,null)
u.b=t
w=document.createElement("simple-html-custom-whitelist-example")
u.c=w
v.b=u
v.a=new S.lK()
v.F(w)},
P:function(d,e,f){var w
if(d===C.aF&&0===e){w=this.e
return w==null?this.e=P.nL(H.a([P.aa6("https","developers.google.com","",null),P.aa6("https","wordpress.org","plugins/amp/",null)],x.C),x.k):w}return f}}
Y.Ul.prototype={
qT:function(d,e){return T.aQ("Visit "+d+"this site"+d+"!",null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",H.a([d,e],x.M),null)}}
G.hU.prototype={}
E.Dk.prototype={
gmi:function(){var w=this.r
return w==null?this.r=document:w},
gxr:function(){var w=this.y
return w==null?this.y=window:w},
gmj:function(){var w,v=this,u=v.z
if(u==null){u=v.d
w=u.a
u=u.b
u=T.bx(w.l(C.b,u),w.l(C.D,u),w.n(C.f,u),v.gxr())
v.z=u}return u},
gxf:function(){var w,v=this,u=v.Q
if(u==null){u=v.d
u=u.a.n(C.U,u.b)
w=v.gmj()
u=v.Q=new O.bh(u,w)}return u},
gpB:function(){var w=this,v=w.ch
return v==null?w.ch=new K.bi(w.gmi(),w.gmj(),P.bu(null,x.f)):v},
gKg:function(){var w=this.cx
if(w==null){w=this.d
w=T.bB(w.a.n(C.f,w.b))
this.cx=w}return w},
gu2:function(){var w=this.cy
if(w==null){w=this.d
w=G.bF(w.a.l(C.t,w.b))
this.cy=w}return w},
gDM:function(){var w=this,v=w.db
if(v==null){v=w.d
v=G.bJ(w.gmi(),v.a.l(C.u,v.b))
w.db=v}return v},
gDN:function(){var w=this,v=w.dx
if(v==null){v=w.d
v=G.bz(w.gu2(),w.gDM(),v.a.l(C.r,v.b))
w.dx=v}return v},
gu3:function(){var w=this.dy
return w==null?this.dy=!0:w},
gDO:function(){var w=this.fr
return w==null?this.fr=!0:w},
gxl:function(){var w=this.fy
if(w==null){w=this.gmi()
w=this.fy=new R.bk(w.querySelector("head"),w)}return w},
gxs:function(){var w=this.go
return w==null?this.go=X.bE():w},
gxk:function(){var w=this,v=w.id
return v==null?w.id=K.bD(w.gxl(),w.gDN(),w.gu2(),w.gpB(),w.gmj(),w.gxf(),w.gu3(),w.gDO(),w.gxs()):v},
gKi:function(){var w,v,u,t,s=this,r=s.k1
if(r==null){r=s.d
w=r.a
r=r.b
v=w.n(C.f,r)
u=s.gu3()
t=s.gxk()
w.l(C.k,r)
r=s.k1=new X.bg(u,v,t)}return r},
q:function(){var w=this,v=w.a2(),u=K.cI(w,0)
w.e=u
v.appendChild(u.c)
u=w.d
u=u.a.n(C.a9,u.b)
u=new X.ca(u,!J.bA(window.location.href,"enableLatencyCharts=false"))
w.f=u
w.e.K(0,u)},
P:function(d,e,f){var w,v=this
if(0===e){if(d===C.L)return v.gmi()
if(d===C.V){w=v.x
return w==null?v.x=document:w}if(d===C.J)return v.gxr()
if(d===C.b)return v.gmj()
if(d===C.P)return v.gxf()
if(d===C.N)return v.gpB()
if(d===C.a_)return v.gKg()
if(d===C.t)return v.gu2()
if(d===C.u)return v.gDM()
if(d===C.r)return v.gDN()
if(d===C.T)return v.gu3()
if(d===C.F)return v.gDO()
if(d===C.G){w=v.fx
return w==null?v.fx=C.Y:w}if(d===C.R)return v.gxl()
if(d===C.E)return v.gxs()
if(d===C.Q)return v.gxk()
if(d===C.k)return v.gKi()
if(d===C.H){w=v.k2
return w==null?v.k2=C.Z:w}if(d===C.v){w=v.k3
return w==null?v.k3=new K.bp(v.gpB()):w}}return f},
A:function(){var w=this,v=w.a.a,u=w.k4
if(u!==v)w.k4=w.f.a=v
w.e.j()},
G:function(){this.e.k()}}
E.KB.prototype={
q:function(){var w,v,u,t=this,s=new E.Dk(E.S(t,0,3)),r=$.a9t
if(r==null)r=$.a9t=O.bH(C.a,null)
s.b=r
w=document.createElement("simple-html-api")
s.c=w
t.b=s
s=x.P
s=H.a([new D.kN("README","angular_components/lib/simple_html/README.md",X.h('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p>\n<ul>\n<li>Light formatting (bold, italic, newlines).</li>\n<li>Links to external domains (with a customisable whitelist).</li>\n<li>Arbitrary click handlers on substrings within the text.</li>\n</ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dev/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p>\n<ul>\n<li>Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li>\n<li>Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li>\n</ul>\n<p>The alternatives include:</p>\n<ul>\n<li>Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.\n<ul>\n<li>This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li>\n</ul>\n</li>\n<li>Using the <code>[innerHtml]</code> directive with a string argument.\n<ul>\n<li>This is secure but very strict; only very limited tags are allowed.</li>\n<li>The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li>\n<li>The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li>\n</ul>\n</li>\n<li>Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.\n<ul>\n<li>This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li>\n</ul>\n</li>\n</ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p>\n<ol>\n<li>\n<p>Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p>\n</li>\n<li>\n<p>Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p>\n</li>\n<li>\n<p>Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p>\n</li>\n<li>\n<p>Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dev/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dev/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p>\n</li>\n</ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/angulardart/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p>\n<ul>\n<li><code>&lt;simple-html&gt;</code> supports the following safe inline elements:\n<ul>\n<li>Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li>\n<li>Line breaks: <code>&lt;br&gt;</code>.</li>\n<li>Text grouping: <code>&lt;span&gt;</code>.</li>\n<li>Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>, points to\ncertain permitted URIs such as the Help Center, or uses the\n<code>doNotVerifyUrlDestinations</code> flag; see\n(<a href="#uri-whitelisting">URI whitelisting</a>).\n<ul>\n<li>The <code>rel</code> attributes are permitted.</li>\n<li>The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li>\n<li>The <code>title</code> attribute is permitted.</li>\n</ul>\n</li>\n</ul>\n</li>\n<li><code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:\n<ul>\n<li>Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li>\n<li>Paragraphs: <code>&lt;p&gt;</code>.</li>\n</ul>\n</li>\n</ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/angulardart/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h4>Allowing external URIs without a whitelist</h4>\n<p>There are cases where you can not use a whitelist:</p>\n<ul>\n<li>when exposing a whitelist through client code is not acceptable, or</li>\n<li>the whitelist is not fixed</li>\n</ul>\n<p>When the URIs come from a <em>safe</em> source, such as internally sourced URIs, you\ncan consider enabling the <code>doNotVerifyUrlDestinations</code> flag. This will allow any\nURI with the <code>http</code>, <code>https</code> or <code>mailto</code> scheme to be inserted, and should\ntherefore be used with caution.</p>\n<p>For example:</p>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html doNotVerifyUrlDestinations\n               [contents]="internalMessages.someMessage"&gt;&lt;/simple-html&gt;\n&lt;/my-template&gt;\n</code></pre>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p>\n<ul>\n<li>Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li>\n<li>Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li>\n</ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p>\n<ul>\n<li>Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li>\n<li>More dangerous cases (such as setting the URL of an iframe) must still be\ndone using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at all.)</li>\n</ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p>\n<ol>\n<li>Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li>\n<li>Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dev/documentation/angular_compiler/latest/v1_src_metadata_directives/Component-class.html">@Component</a>\'s\ndirective list.</li>\n<li>For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li>\n<li>In your template file, bind the message with either:\n<ul>\n<li><code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span [innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li>\n<li><code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li>\n</ul>\n</li>\n<li>Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li>\n<li>Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li>\n<li>If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li>\n</ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p>\n<ul>\n<li><strong>The message appears empty</strong>\n<ul>\n<li>Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li>\n</ul>\n</li>\n</ul>\n')),new D.b5("SimpleHtmlComponent",!1,"","simple-html","","angular_components/lib/simple_html/simple_html.dart",X.h('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p>\n<ul>\n<li><code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li>\n<li><code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li>\n</ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the attribute doNotVerifyUrlDestinations is present, external URLs will\nnot be verified, except for their URI scheme. This is flag should only ever\nbe used for URLs that come from a safe source, such as internal\ndocumentation.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([new D.j("contents","","String*",X.h("<p>HTML to display in the component.</p>\n"),!1,"")],s),H.a([new D.j("trigger","","Stream<UIEvent*>*",X.h("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),!1,"")],s))],x.c)
v=H.a([new R.aJ(C.ha,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.aJ(C.hw,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],x.D)
u=x.R
t.a=new G.hU(R.cQ(H.a([],x.i),v,s,P.aW(u,u),!0))
t.F(w)}}
var z=a.updateTypes(["~()","f<lJ*>*()","f<lI*>*()","f<k_*>*()","f<lK*>*()","f<hU*>*()"])
F.Yk.prototype={
$0:function(){var w,v,u,t=this.a
if(t.b==null)t.b=t.gI2(t)
t.d.H()
v=t.b
if(v==null)return
try{J.anu(v,this.b,t.e)}catch(u){w=H.bb(u)
if(w instanceof F.wv)$.a4B().jQ(C.ds,"simple-html used untrusted URI: "+H.B(w),w,null)
else if(w instanceof F.vJ)$.a4B().jQ(C.ds,"simple-html used malformed element: "+H.B(w),w,null)
else throw u}t.a.du(new F.Yj(t))},
$S:0}
F.Yj.prototype={
$0:function(){var w=this.a,v=x.h
new H.bj(new W.fv(w.b.querySelectorAll("a.trigger"),v),new F.Yi(w),v.i("bj<X.E,be<V*>*>")).b2(0,H.dy(w.d.gFh(),x.O))},
$S:0}
F.Yi.prototype={
$1:function(d){var w=J.anb(d),v=this.a.c
return W.cz(w.a,w.b,v.giA(v),!1,w.$ti.c)},
$S:213}
F.Yg.prototype={
$1:function(d){var w=d.gd1(d).length===0||C.d.jl(d.gd1(d),"/"),v="Whitelisted URIs with a path must end with a slash, which "+d.N(0)+" does not"
if(!w)H.Y(P.cA(N.ask(v,null)))
return null},
$S:214}
F.Yf.prototype={
$1:function(d){var w=this.a
return d.glN(d)===w.glN(w)&&C.d.ca(w.gd1(w),d.gd1(d))},
$S:215};(function installTearOffs(){var w=a._static_0,v=a._instance_0u
w(G,"aCM","aMU",1)
w(G,"aCL","aMT",2)
v(R.k_.prototype,"gZv","Zw",0)
w(A,"akX","aMW",3)
w(F,"akW","aMV",4)
w(E,"ahM","aMS",5)})();(function inheritance(){var w=a.mixin,v=a.inheritMany,u=a.inherit
v(P.y,[P.Fu,F.Yh,F.we,F.Ye,F.Xu,R.k_,S.lK,Y.Ul,G.hU])
u(P.yh,P.qM)
u(P.wu,P.yh)
v(F.Yh,[F.lJ,F.lI])
v(H.bq,[F.Yk,F.Yj,F.Yi,F.Yg,F.Yf])
v(P.f1,[F.wv,F.vJ])
v(E.bn,[G.Dm,G.Dl,A.Do,F.Dn,E.Dk])
v(G.f,[G.KD,G.KC,A.KF,F.KE,E.KB])
w(P.yh,P.Fu)})()
H.ak(b.typeUniverse,JSON.parse('{"al":"w","ax":"w","ap":"ae","am":"o","aB":"o","aD":"o","an":"G","ao":"G","at":"I","ay":"I","aq":"A","aA":"A","aG":"O","aF":"a3","aE":"a9","av":"U","aw":"ac","aC":"V","az":"ah","au":"af","as":"ai","ar":"a1","wu":{"cw":["1"],"ft":["1"],"a_":["1"],"M":["1"],"cw.E":"1"},"wv":{"ck":[]},"vJ":{"ck":[]},"we":{"fr":[]},"Dm":{"k":[],"i":[]},"KD":{"f":["lJ*"],"i":[],"f.T":"lJ*"},"Dl":{"k":[],"i":[]},"KC":{"f":["lI*"],"i":[],"f.T":"lI*"},"Do":{"k":[],"i":[]},"KF":{"f":["k_*"],"i":[],"f.T":"k_*"},"Dn":{"k":[],"i":[]},"KE":{"f":["lK*"],"i":[],"f.T":"lK*"},"Dk":{"k":[],"i":[]},"KB":{"f":["hU*"],"i":[],"f.T":"hU*"}}'))
H.dn(b.typeUniverse,JSON.parse('{"Fu":1,"yh":1}'))
var y={c:"`null` encountered as the result from expression with type `Never`."}
var x=(function rtii(){var w=H.K
return{V:w("l<hU*>"),X:w("l<lI*>"),x:w("l<lJ*>"),y:w("l<lK*>"),s:w("l<k_*>"),Q:w("q<fr>"),S:w("q<t>"),P:w("q<j*>"),D:w("q<aJ*>"),c:w("q<cZ*>"),M:w("q<y*>"),a:w("q<be<~>*>"),i:w("q<t*>"),C:w("q<iI*>"),h:w("fv<aT*>"),K:w("N<U*>"),f:w("D<t*>*"),O:w("V*"),R:w("t*"),p:w("U*"),k:w("iI*")}})();(function constants(){var w=a.makeConstList
C.c6=new Y.Ul()
C.ha=new D.l("simple-html-example",A.akX(),x.s)
C.hi=new D.l("simple-html-api",E.ahM(),x.V)
C.hw=new D.l("simple-html-custom-whitelist-example",F.akW(),x.y)
C.cn=H.a(w([0,0,65498,45055,65535,34815,65534,18431]),H.K("q<H*>"))
C.aF=new L.dd("simpleHtmlUriWhitelist",H.K("dd<D<iI*>*>"))
C.k1=H.a(w(["http","https","mailto"]),x.i)
C.kk=new H.cX(3,{http:null,https:null,mailto:null},C.k1,H.K("cX<t*,W>"))
C.kx=new P.wu(C.kk,H.K("wu<t*>"))
C.n6=H.C("hU")
C.n7=H.C("lI")
C.n8=H.C("lJ")
C.n9=H.C("k_")
C.nJ=H.C("lK")})();(function staticFields(){$.al_=["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]
$.a9w=null
$.a9v=null
$.aaM=!1
$.aF_=["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]
$.a9y=null
$.acU=!1
$.a9x=null
$.aaL=!1
$.a9t=null
$.aaK=!1
$.aEW=[$.al_]
$.aEV=[$.al_]
$.aEX=[$.aF_]})();(function lazyInitializers(){var w=a.lazyOld
w($,"aPQ","a4G",function(){return P.nL(H.a([],x.C),x.k)})
w($,"aPn","a4B",function(){return F.A_("_SimpleHtmlBase")})})()}
$__dart_deferred_initializers__["lSyQ+/7j2b+w5mIin+W952B1rY8="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_74.part.js.map
