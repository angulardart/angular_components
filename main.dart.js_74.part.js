self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={wv:function wv(d,e){this.a=d
this.$ti=e},
aa_:function(d,e,f,g){var x,w,v,u,t,s,r,q,p,o,n,m=null,l=e.length
if(l!==0){v=0
while(!0){if(!(v<l)){x=""
w=0
break}if(C.d.bz(e,v)===64){x=C.d.b0(e,0,v)
w=v+1
break}++v}if(w<l&&C.d.bz(e,w)===91){for(u=w,t=-1;u<l;++u){s=C.d.bz(e,u)
if(s===37&&t<0){r=C.d.dz(e,"25",u+1)?u+2:u
t=u
u=r}else if(s===93)break}if(u===l)throw H.p(P.cu("Invalid IPv6 host entry.",e,w))
q=t<0?u:t
P.a2y(e,w+1,q);++u
if(u!==l&&C.d.bz(e,u)!==58)throw H.p(P.cu("Invalid end of authority",e,u))}else u=w
while(!0){if(!(u<l)){p=m
break}if(C.d.bz(e,u)===58){o=C.d.cw(e,u+1)
p=o.length!==0?P.fJ(o,m):m
break}++u}n=C.d.b0(e,w,u)}else{p=m
n=p
x=""}return P.aqZ(n,m,H.a(f.split("/"),y.S),p,g,d,x)}},W,G={
mE:function(d,e){var x,w=new G.Dm(E.T(d,e,1)),v=$.a9p
if(v==null)v=$.a9p=O.a1($.aEP,null)
w.b=v
x=document.createElement("simple-html")
w.c=x
return w},
aMN:function(){return new G.KB(new G.S())},
a9n:function(d,e){var x,w=new G.Dl(E.T(d,e,1)),v=$.a9o
if(v==null)v=$.a9o=O.a1($.aEO,null)
w.b=v
x=document.createElement("simple-html-block")
w.c=x
return w},
aMM:function(){return new G.KA(new G.S())},
aiV:function(){if($.aaE)return
$.aaE=!0
$.V.w(0,C.n8,new D.l("simple-html",G.aCF(),y.x))
$.V.w(0,C.n7,new D.l("simple-html-block",G.aCE(),y.X))
E.G()
V.e1()},
Dm:function Dm(d){var _=this
_.c=_.b=_.a=null
_.d=d},
KB:function KB(d){var _=this
_.c=_.b=_.a=null
_.d=d},
Dl:function Dl(d){var _=this
_.c=_.b=_.a=null
_.d=d},
KA:function KA(d){var _=this
_.c=_.b=_.a=null
_.d=d},
iG:function iG(d){this.a=d}},Y={Ui:function Ui(){}},R={kl:function kl(){this.a=0}},K,V,E={
aq0:function(){return C.hi},
aML:function(){return new E.Kz(new G.S())},
av6:function(){if($.aaC)return
$.aaC=!0
$.V.w(0,C.n6,new D.l("simple-html-api",E.ahE(),y.V))
E.G()
K.dj()
D.d3()
A.aws()
F.axp()},
Dk:function Dk(d){var _=this
_.c=_.b=_.a=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
Kz:function Kz(d){var _=this
_.c=_.b=_.a=null
_.d=d}},M,Q,D,Z,O,A={
aMP:function(){return new A.KD(new G.S())},
aws:function(){if($.acM)return
$.acM=!0
$.V.w(0,C.n9,new D.l("simple-html-example",A.akQ(),y.s))
E.G()
G.aiV()},
Do:function Do(d){var _=this
_.c=_.b=_.a=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KD:function KD(d){var _=this
_.c=_.b=_.a=null
_.d=d}},T,L,N,U,X,B,S={lK:function lK(){}},F={
mz:function(d,e,f,g){var x=f==null?$.a4D():f
x=F.aaq(x,E.iT(g,!1))
return new F.lJ(e,d,new P.P(null,null,y.K),new R.aO(!1),new F.we(x))},
a69:function(d,e,f,g){var x,w=f==null?$.a4D():f
w=F.aaq(w,E.iT(g,!1))
x=y.i
w.h5("p",H.a(["class"],x))
w.h5("ul",H.a(["class"],x))
w.h5("li",H.a(["class"],x))
return new F.lI(e,d,new P.P(null,null,y.K),new R.aO(!1),new F.we(w))},
Yz:function(d,e){return new F.ww(!1,null,null,"Unsafe URI "+H.C(d)+" because "+e)},
XQ:function(d,e){return new F.vJ(!1,null,null,"Element "+H.C(d)+" was malformed: "+e)},
aas:function(d){var x,w,v=null
try{v=P.a2x(d)}catch(x){H.bd(x)
w=F.Yz(d,"Could not parse")
throw H.p(w)}return P.a6i().p1(v)},
aqN:function(d){var x=new F.Yd(P.nO(d,y.k))
x.Kl(d)
return x},
aaq:function(d,e){var x=e?new F.Xs():F.aqN(d),w=new W.pX(H.a([],y.Q)),v=y.i
w.Fk("a",H.a(["class","href","rel","target","title"],v),x)
w.h5("b",H.a(["class"],v))
w.h5("br",H.a(["class"],v))
w.h5("em",H.a(["class"],v))
w.h5("i",H.a(["class"],v))
w.h5("span",H.a(["class"],v))
w.h5("strong",H.a(["class"],v))
return w},
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
Yg:function Yg(){},
Yj:function Yj(d,e){this.a=d
this.b=e},
Yi:function Yi(d){this.a=d},
Yh:function Yh(d){this.a=d},
ww:function ww(d,e,f,g){var _=this
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
Yd:function Yd(d){this.a=d},
Yf:function Yf(){},
Ye:function Ye(d){this.a=d},
Xs:function Xs(){},
aMO:function(){return new F.KC(new G.S())},
axp:function(){if($.aaD)return
$.aaD=!0
$.V.w(0,C.nJ,new D.l("simple-html-custom-whitelist-example",F.akP(),y.y))
E.G()
G.aiV()},
Dn:function Dn(d){var _=this
_.c=_.b=_.a=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KC:function KC(d){var _=this
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
P.wv.prototype={
aP:function(d,e){return J.a1K(this.a,e)},
gb3:function(d){return J.bQ(J.a1N(this.a))},
gM:function(d){return J.bX(this.a)},
R:function(d,e){throw H.p(P.aL("Cannot change unmodifiable set"))},
bD:function(d,e){throw H.p(P.aL("Cannot change unmodifiable set"))}}
F.lJ.prototype={
gI2:function(d){var x=this.f,w=x.children
if(x.firstElementChild==null)x=null
else{x=new W.of(x,w)
x=x.gdw(x)}return x}}
F.lI.prototype={
gI2:function(d){var x=this.f,w=x.children
if(x.firstElementChild==null)x=null
else{x=new W.of(x,w)
x=x.gdw(x)}return x}}
F.Yg.prototype={
sh6:function(d){this.a.cL(new F.Yj(this,d))}}
F.ww.prototype={}
F.vJ.prototype={}
F.we.prototype={
fu:function(d){if(!this.a.fu(d))throw H.p(F.XQ(d,"prohibited element"))
return!0},
fg:function(d,e,f){var x,w
if(d.tagName.toLowerCase()==="a"&&e==="target"){x=d.hasAttribute("rel")
if(!x)throw H.p(F.XQ(d,"did not set rel attribute"))
w=d.getAttribute("rel")
if(!C.e.aP(H.a(w.split(" "),y.S),"noopener"))throw H.p(F.XQ(d,"did not set link type noopener (only "+w+")"))}if(!this.a.fg(d,e,f))throw H.p(F.XQ(d,"prohibited attribute "+e+" with value "+H.C(f)))
return!0},
$ifZ:1}
F.Yd.prototype={
Kl:function(d){C.e.b2(this.a,new F.Yf())},
lc:function(d){var x,w,v,u=F.aas(d),t=null
try{t=J.an7(u)}catch(x){H.bd(x)
w=F.Yz(d,"Resolved URI "+H.C(u)+" had no origin")
throw H.p(w)}w=t
v=P.a6i()
if(!J.ab(w,v.glN(v))&&!this.NT(u))throw H.p(F.Yz(d,"Different origin and non-whitelisted URL"))
return!0},
NT:function(d){return C.e.cM(this.a,new F.Ye(d))}}
F.Xs.prototype={
lc:function(d){var x=F.aas(d)
if(!J.a1K(C.kx.a,x.ghx()))throw H.p(F.Yz(d,"URI scheme "+x.ghx()+" not allowed"))
return!0}}
G.Dm.prototype={
q:function(){var x=this.a2()
this.m(T.dZ(document,x))}}
G.KB.prototype={
q:function(){var x,w=this,v=G.mE(w,0)
w.b=v
x=v.c
v=F.mz(w.n(C.b,null),x,w.l(C.aG,null),null)
w.a=v
w.F(x)},
A:function(){this.b.j()},
G:function(){this.a.d.H()}}
G.Dl.prototype={
q:function(){var x=this.a2()
this.h(T.v(document,x))}}
G.KA.prototype={
q:function(){var x,w=this,v=G.a9n(w,0)
w.b=v
x=v.c
v=F.a69(w.n(C.b,null),x,w.l(C.aG,null),null)
w.a=v
w.F(x)},
A:function(){this.b.j()},
G:function(){this.a.d.H()}}
R.kl.prototype={
Zv:function(){return this.a++}}
A.Do.prototype={
q:function(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i=this,h=null,g=i.a,f=i.a2(),e=document,d=T.d(e,f,"h2")
i.m(d)
T.b(d,"SimpleHTML with default URI whitelist")
x=T.d(e,f,"p")
i.m(x)
w=G.mE(i,3)
i.e=w
v=w.c
x.appendChild(v)
i.h(v)
w=i.d
u=w.a
w=w.b
t=F.mz(u.n(C.b,w),v,u.l(C.aG,w),h)
i.f=t
i.e.K(0,t)
s=T.d(e,f,"ul")
i.h(s)
r=T.d(e,s,"li")
i.m(r)
t=G.mE(i,6)
i.r=t
q=t.c
r.appendChild(q)
i.h(q)
t=F.mz(u.n(C.b,w),q,u.l(C.aG,w),h)
i.x=t
i.r.K(0,t)
p=T.d(e,s,"li")
i.m(p)
t=G.mE(i,8)
i.y=t
o=t.c
p.appendChild(o)
i.h(o)
t=F.mz(u.n(C.b,w),o,u.l(C.aG,w),h)
i.z=t
i.y.K(0,t)
n=T.d(e,f,"p")
i.m(n)
T.b(n,"The following message is removed due to disallowed HTML: [")
t=G.mE(i,11)
i.Q=t
m=t.c
n.appendChild(m)
i.h(m)
t=F.mz(u.n(C.b,w),m,u.l(C.aG,w),h)
i.ch=t
i.Q.K(0,t)
T.b(n,"]")
l=T.d(e,f,"p")
i.m(l)
t=G.mE(i,14)
i.cx=t
k=t.c
l.appendChild(k)
i.O(k,"click-target")
i.h(k)
t=F.mz(u.n(C.b,w),k,u.l(C.aG,w),h)
i.cy=t
i.cx.K(0,t)
t=G.a9n(i,15)
i.db=t
j=t.c
f.appendChild(j)
i.h(j)
w=F.a69(u.n(C.b,w),j,u.l(C.aG,w),h)
i.dx=w
i.db.K(0,w)
w=i.cy.c
i.bo(H.a([new P.e(w,H.m(w).i("e<1>")).D(i.ad(g.gZu(),y.p))],y.a))},
A:function(){var x,w,v,u,t,s,r,q,p,o=this,n=null,m=o.a
m.toString
x=y.M
w=T.aS('I <b>love</b> using <span class="highlight">HTML</span>.',n,"SimpleHtmlExampleMessages_messageWithFormatting",H.a(["<b>","</b>",'<span class="highlight">',"</span>"],x),n)
v=o.dy
if(v!=w){o.f.sh6(w)
o.dy=w
u=!0}else u=!1
if(u)o.e.d.st(1)
t=T.aS('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',n,"SimpleHtmlExampleMessages_messageLink",H.a(['<a href="localpage.html?param=1#test_fragment">',"</a>"],x),n)
v=o.fr
if(v!=t){o.x.sh6(t)
o.fr=t
u=!0}else u=!1
if(u)o.r.d.st(1)
s=T.aS('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',n,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",H.a(['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],x),n)
v=o.fx
if(v!=s){o.z.sh6(s)
o.fx=s
u=!0}else u=!1
if(u)o.y.d.st(1)
r=T.aS('Please consult my <a href="https://hecuba.org">suspicious website</a>.',n,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",H.a(['<a href="https://hecuba.org">',"</a>"],x),n)
v=o.fy
if(v!=r){o.ch.sh6(r)
o.fy=r
u=!0}else u=!1
if(u)o.Q.d.st(1)
v=m.a
q=T.aS('You <a class="trigger">clicked here</a> '+v+" times.",n,"SimpleHtmlExampleMessages_messageWithClickHandler",H.a([v,'<a class="trigger">',"</a>"],x),n)
v=o.go
if(v!=q){o.cy.sh6(q)
o.go=q
u=!0}else u=!1
if(u)o.cx.d.st(1)
p=T.aS("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",n,"SimpleHtmlExampleMessages_blockMessage",H.a(["<b>","</b>","<ul>","</ul>","<li>","</li>"],x),n)
x=o.id
if(x!=p){o.dx.sh6(p)
o.id=p
u=!0}else u=!1
if(u)o.db.d.st(1)
o.e.j()
o.r.j()
o.y.j()
o.Q.j()
o.cx.j()
o.db.j()},
G:function(){var x=this
x.e.k()
x.r.k()
x.y.k()
x.Q.k()
x.cx.k()
x.db.k()
x.f.d.H()
x.x.d.H()
x.z.d.H()
x.ch.d.H()
x.cy.d.H()
x.dx.d.H()}}
A.KD.prototype={
q:function(){var x,w=this,v=new A.Do(E.T(w,0,3)),u=$.a9r
if(u==null)u=$.a9r=O.a1($.aEQ,null)
v.b=u
x=document.createElement("simple-html-example")
v.c=x
w.b=v
w.a=new R.kl()
w.F(x)}}
S.lK.prototype={}
F.Dn.prototype={
q:function(){var x,w,v,u,t,s,r,q,p,o,n=this,m="(removed)",l=n.a2(),k=document
T.b(T.d(k,l,"h2"),"SimpleHTML with a custom URI whitelist")
x=T.d(k,l,"ul")
w=T.d(k,x,"li")
v=G.mE(n,4)
n.e=v
u=v.c
w.appendChild(u)
v=n.d
t=v.a
v=v.b
s=F.mz(t.n(C.b,v),u,t.l(C.aG,v),null)
n.f=s
n.e.K(0,s)
r=T.d(k,x,"li")
s=G.mE(n,6)
n.r=s
q=s.c
r.appendChild(q)
s=F.mz(t.n(C.b,v),q,t.l(C.aG,v),null)
n.x=s
n.r.K(0,s)
T.b(r,m)
p=T.d(k,x,"li")
s=G.mE(n,9)
n.y=s
o=s.c
p.appendChild(o)
v=F.mz(t.n(C.b,v),o,t.l(C.aG,v),null)
n.z=v
n.y.K(0,v)
T.b(p,m)},
A:function(){var x,w,v,u,t,s=this,r="</a>"
s.a.toString
x=C.c7.qQ('<a href="'+H.C(P.qU(C.co,"https://wordpress.org/plugins/amp/",C.aJ,!1))+'">',r)
w=s.Q
if(w!=x){s.f.sh6(x)
s.Q=x
v=!0}else v=!1
if(v)s.e.d.st(1)
u=C.c7.qQ('<a href="'+H.C(P.qU(C.co,"https://wordpress.org/plugins/malware/",C.aJ,!1))+'">',r)
w=s.ch
if(w!=u){s.x.sh6(u)
s.ch=u
v=!0}else v=!1
if(v)s.r.d.st(1)
t=C.c7.qQ('<a href="'+H.C(P.qU(C.co,"javascript:alert('!')",C.aJ,!1))+'">',r)
w=s.cx
if(w!=t){s.z.sh6(t)
s.cx=t
v=!0}else v=!1
if(v)s.y.d.st(1)
s.e.j()
s.r.j()
s.y.j()},
G:function(){var x=this
x.e.k()
x.r.k()
x.y.k()
x.f.d.H()
x.x.d.H()
x.z.d.H()}}
F.KC.prototype={
q:function(){var x,w=this,v=new F.Dn(E.T(w,0,3)),u=$.a9q
if(u==null)u=$.a9q=O.bM(C.a,null)
v.b=u
x=document.createElement("simple-html-custom-whitelist-example")
v.c=x
w.b=v
w.a=new S.lK()
w.F(x)},
P:function(d,e,f){var x
if(d===C.aG&&0===e){x=this.e
return x==null?this.e=P.nO(H.a([P.aa_("https","developers.google.com","",null),P.aa_("https","wordpress.org","plugins/amp/",null)],y.C),y.k):x}return f}}
Y.Ui.prototype={
qQ:function(d,e){return T.aS("Visit "+d+"this site"+d+"!",null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",H.a([d,e],y.M),null)}}
G.iG.prototype={}
E.Dk.prototype={
gmi:function(){var x=this.r
return x==null?this.r=document:x},
gxp:function(){var x=this.y
return x==null?this.y=window:x},
gmj:function(){var x,w=this,v=w.z
if(v==null){v=w.d
x=v.a
v=v.b
v=T.bC(x.l(C.b,v),x.l(C.D,v),x.n(C.f,v),w.gxp())
w.z=v}return v},
gxd:function(){var x,w=this,v=w.Q
if(v==null){v=w.d
v=v.a.n(C.U,v.b)
x=w.gmj()
v=w.Q=new O.bk(v,x)}return v},
gpA:function(){var x=this,w=x.ch
return w==null?x.ch=new K.bl(x.gmi(),x.gmj(),P.bA(null,y.f)):w},
gKg:function(){var x=this.cx
if(x==null){x=this.d
x=T.bG(x.a.n(C.f,x.b))
this.cx=x}return x},
gu_:function(){var x=this.cy
if(x==null){x=this.d
x=G.bL(x.a.l(C.t,x.b))
this.cy=x}return x},
gDL:function(){var x=this,w=x.db
if(w==null){w=x.d
w=G.bO(x.gmi(),w.a.l(C.u,w.b))
x.db=w}return w},
gDM:function(){var x=this,w=x.dx
if(w==null){w=x.d
w=G.bE(x.gu_(),x.gDL(),w.a.l(C.r,w.b))
x.dx=w}return w},
gu0:function(){var x=this.dy
return x==null?this.dy=!0:x},
gDN:function(){var x=this.fr
return x==null?this.fr=!0:x},
gxj:function(){var x=this.fy
if(x==null){x=this.gmi()
x=this.fy=new R.bn(x.querySelector("head"),x)}return x},
gxq:function(){var x=this.go
return x==null?this.go=X.bK():x},
gxi:function(){var x=this,w=x.id
return w==null?x.id=K.bI(x.gxj(),x.gDM(),x.gu_(),x.gpA(),x.gmj(),x.gxd(),x.gu0(),x.gDN(),x.gxq()):w},
gKi:function(){var x,w,v,u,t=this,s=t.k1
if(s==null){s=t.d
x=s.a
s=s.b
w=x.n(C.f,s)
v=t.gu0()
u=t.gxi()
x.l(C.k,s)
s=t.k1=new X.bj(v,w,u)}return s},
q:function(){var x,w=this,v=w.a2(),u=K.cS(w,0)
w.e=u
v.appendChild(u.c)
u=w.d
x=u.a
u=u.b
x.n(C.a9,u)
u=x.n(C.aa,u)
u=new X.bf(u,!J.bF(window.location.href,"enableLatencyCharts=false"))
w.f=u
w.e.K(0,u)},
P:function(d,e,f){var x,w=this
if(0===e){if(d===C.L)return w.gmi()
if(d===C.V){x=w.x
return x==null?w.x=document:x}if(d===C.J)return w.gxp()
if(d===C.b)return w.gmj()
if(d===C.P)return w.gxd()
if(d===C.N)return w.gpA()
if(d===C.a_)return w.gKg()
if(d===C.t)return w.gu_()
if(d===C.u)return w.gDL()
if(d===C.r)return w.gDM()
if(d===C.T)return w.gu0()
if(d===C.F)return w.gDN()
if(d===C.G){x=w.fx
return x==null?w.fx=C.Y:x}if(d===C.R)return w.gxj()
if(d===C.E)return w.gxq()
if(d===C.Q)return w.gxi()
if(d===C.k)return w.gKi()
if(d===C.H){x=w.k2
return x==null?w.k2=C.Z:x}if(d===C.v){x=w.k3
return x==null?w.k3=new K.bt(w.gpA()):x}}return f},
A:function(){var x=this,w=x.a.a,v=x.k4
if(v!==w)x.k4=x.f.a=w
x.e.j()},
G:function(){this.e.k()}}
E.Kz.prototype={
q:function(){var x,w,v,u=this,t=new E.Dk(E.T(u,0,3)),s=$.a9m
if(s==null)s=$.a9m=O.bM(C.a,null)
t.b=s
x=document.createElement("simple-html-api")
t.c=x
u.b=t
t=y.P
t=H.a([new D.l2("README","angular_components/lib/simple_html/README.md",X.h('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p>\n<ul>\n<li>Light formatting (bold, italic, newlines).</li>\n<li>Links to external domains (with a customisable whitelist).</li>\n<li>Arbitrary click handlers on substrings within the text.</li>\n</ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p>\n<ul>\n<li>Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li>\n<li>Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li>\n</ul>\n<p>The alternatives include:</p>\n<ul>\n<li>Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.\n<ul>\n<li>This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li>\n</ul>\n</li>\n<li>Using the <code>[innerHtml]</code> directive with a string argument.\n<ul>\n<li>This is secure but very strict; only very limited tags are allowed.</li>\n<li>The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li>\n<li>The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li>\n</ul>\n</li>\n<li>Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.\n<ul>\n<li>This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li>\n</ul>\n</li>\n</ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p>\n<ol>\n<li>\n<p>Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p>\n</li>\n<li>\n<p>Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p>\n</li>\n<li>\n<p>Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p>\n</li>\n<li>\n<p>Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p>\n</li>\n</ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p>\n<ul>\n<li><code>&lt;simple-html&gt;</code> supports the following safe inline elements:\n<ul>\n<li>Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li>\n<li>Line breaks: <code>&lt;br&gt;</code>.</li>\n<li>Text grouping: <code>&lt;span&gt;</code>.</li>\n<li>Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>, points to\ncertain permitted URIs such as the Help Center, or uses the\n<code>doNotVerifyUrlDestinations</code> flag; see\n(<a href="#uri-whitelisting">URI whitelisting</a>).\n<ul>\n<li>The <code>rel</code> attributes are permitted.</li>\n<li>The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li>\n<li>The <code>title</code> attribute is permitted.</li>\n</ul>\n</li>\n</ul>\n</li>\n<li><code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:\n<ul>\n<li>Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li>\n<li>Paragraphs: <code>&lt;p&gt;</code>.</li>\n</ul>\n</li>\n</ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h4>Allowing external URIs without a whitelist</h4>\n<p>There are cases where you can not use a whitelist:</p>\n<ul>\n<li>when exposing a whitelist through client code is not acceptable, or</li>\n<li>the whitelist is not fixed</li>\n</ul>\n<p>When the URIs come from a <em>safe</em> source, such as internally sourced URIs, you\ncan consider enabling the <code>doNotVerifyUrlDestinations</code> flag. This will allow any\nURI with the <code>http</code>, <code>https</code> or <code>mailto</code> scheme to be inserted, and should\ntherefore be used with caution.</p>\n<p>For example:</p>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html doNotVerifyUrlDestinations\n               [contents]="internalMessages.someMessage"&gt;&lt;/simple-html&gt;\n&lt;/my-template&gt;\n</code></pre>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p>\n<ul>\n<li>Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li>\n<li>Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li>\n</ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p>\n<ul>\n<li>Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li>\n<li>More dangerous cases (such as setting the URL of an iframe) must still be\ndone using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at all.)</li>\n</ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p>\n<ol>\n<li>Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li>\n<li>Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dartlang.org/documentation/angular/latest/angular/Component-class.html">@Component</a>\'s\ndirective list.</li>\n<li>For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li>\n<li>In your template file, bind the message with either:\n<ul>\n<li><code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span [innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li>\n<li><code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li>\n</ul>\n</li>\n<li>Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li>\n<li>Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li>\n<li>If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li>\n</ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p>\n<ul>\n<li><strong>The message appears empty</strong>\n<ul>\n<li>Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li>\n</ul>\n</li>\n</ul>\n')),new D.b6("SimpleHtmlComponent",!1,"","simple-html","","angular_components/lib/simple_html/simple_html.dart",X.h('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p>\n<ul>\n<li><code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li>\n<li><code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li>\n</ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the attribute doNotVerifyUrlDestinations is present, external URLs will\nnot be verified, except for their URI scheme. This is flag should only ever\nbe used for URLs that come from a safe source, such as internal\ndocumentation.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([new D.j("contents","","String",X.h("<p>HTML to display in the component.</p>\n"),!1,"")],t),H.a([new D.j("trigger","","Stream<UIEvent>",X.h("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),!1,"")],t))],y.c)
w=H.a([new R.aK(C.ha,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.aK(C.hw,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],y.D)
v=y.R
u.a=new G.iG(R.d_(H.a([],y.i),w,t,P.aX(v,v),!0))
u.F(x)}}
var z=a.updateTypes(["~()","f<lJ*>*()","f<lI*>*()","f<kl*>*()","f<lK*>*()","f<iG*>*()"])
F.Yj.prototype={
$0:function(){var x,w,v,u=this.a
if(u.b==null)u.b=u.gI2(u)
u.d.H()
w=u.b
if(w==null)return
try{J.ano(w,this.b,u.e)}catch(v){x=H.bd(v)
if(x instanceof F.ww)$.a4y().jP(C.dt,"simple-html used untrusted URI: "+H.C(x),x,null)
else if(x instanceof F.vJ)$.a4y().jP(C.dt,"simple-html used malformed element: "+H.C(x),x,null)
else throw v}u.a.du(new F.Yi(u))},
$S:0}
F.Yi.prototype={
$0:function(){var x=this.a,w=y.h
new H.bm(new W.h2(x.b.querySelectorAll("a.trigger"),w),new F.Yh(x),w.i("bm<Y.E,bh<X*>*>")).b2(0,H.dN(x.d.gFg(),y.O))},
$S:0}
F.Yh.prototype={
$1:function(d){var x=J.an5(d),w=this.a.c
return W.cN(x.a,x.b,w.giA(w),!1,x.$ti.c)},
$S:214}
F.Yf.prototype={
$1:function(d){var x=d.gd1(d).length===0||C.d.jk(d.gd1(d),"/"),w="Whitelisted URIs with a path must end with a slash, which "+d.N(0)+" does not"
if(!x)H.a0(P.cX(N.ase(w,null)))
return null},
$S:215}
F.Ye.prototype={
$1:function(d){var x=this.a
return d.glN(d)===x.glN(x)&&C.d.ca(x.gd1(x),d.gd1(d))},
$S:216};(function installTearOffs(){var x=a._static_0,w=a._instance_0u
x(G,"aCF","aMN",1)
x(G,"aCE","aMM",2)
w(R.kl.prototype,"gZu","Zv",0)
x(A,"akQ","aMP",3)
x(F,"akP","aMO",4)
x(E,"ahE","aML",5)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(P.wv,P.qP)
w(P.y,[F.Yg,F.we,F.Yd,F.Xs,R.kl,S.lK,Y.Ui,G.iG])
w(F.Yg,[F.lJ,F.lI])
w(H.bv,[F.Yj,F.Yi,F.Yh,F.Yf,F.Ye])
w(P.fr,[F.ww,F.vJ])
w(E.br,[G.Dm,G.Dl,A.Do,F.Dn,E.Dk])
w(G.f,[G.KB,G.KA,A.KD,F.KC,E.Kz])})()
H.al(b.typeUniverse,JSON.parse('{"am":"w","ay":"w","aq":"af","an":"o","aC":"o","aE":"o","ao":"H","ap":"H","au":"J","az":"J","ar":"B","aB":"B","aH":"O","aG":"a4","aF":"a9","aw":"W","ax":"ad","aD":"X","aA":"ah","av":"ag","at":"ai","as":"a2","wv":{"cK":["1"],"h0":["1"],"a_":["1"],"N":["1"],"cK.E":"1"},"ww":{"ct":[]},"vJ":{"ct":[]},"we":{"fZ":[]},"Dm":{"k":[],"i":[]},"KB":{"f":["lJ*"],"i":[],"f.T":"lJ*"},"Dl":{"k":[],"i":[]},"KA":{"f":["lI*"],"i":[],"f.T":"lI*"},"Do":{"k":[],"i":[]},"KD":{"f":["kl*"],"i":[],"f.T":"kl*"},"Dn":{"k":[],"i":[]},"KC":{"f":["lK*"],"i":[],"f.T":"lK*"},"Dk":{"k":[],"i":[]},"Kz":{"f":["iG*"],"i":[],"f.T":"iG*"}}'))
0
var y=(function rtii(){var x=H.K
return{V:x("l<iG*>"),X:x("l<lI*>"),x:x("l<lJ*>"),y:x("l<lK*>"),s:x("l<kl*>"),Q:x("q<fZ>"),S:x("q<t>"),P:x("q<j*>"),D:x("q<aK*>"),c:x("q<dd*>"),M:x("q<y*>"),a:x("q<bh<~>*>"),i:x("q<t*>"),C:x("q<jr*>"),h:x("h2<aU*>"),K:x("P<W*>"),f:x("F<t*>*"),O:x("X*"),R:x("t*"),p:x("W*"),k:x("jr*")}})();(function constants(){var x=a.makeConstList
C.c7=new Y.Ui()
C.ha=new D.l("simple-html-example",A.akQ(),y.s)
C.hi=new D.l("simple-html-api",E.ahE(),y.V)
C.hw=new D.l("simple-html-custom-whitelist-example",F.akP(),y.y)
C.co=H.a(x([0,0,65498,45055,65535,34815,65534,18431]),H.K("q<I*>"))
C.aG=new L.dq("simpleHtmlUriWhitelist",H.K("dq<F<jr*>*>"))
C.k1=H.a(x(["http","https","mailto"]),y.i)
C.kk=new H.d5(3,{http:null,https:null,mailto:null},C.k1,H.K("d5<t*,U>"))
C.kx=new P.wv(C.kk,H.K("wv<t*>"))
C.n6=H.D("iG")
C.n7=H.D("lI")
C.n8=H.D("lJ")
C.n9=H.D("kl")
C.nJ=H.D("lK")})();(function staticFields(){$.akT=["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]
$.a9p=null
$.a9o=null
$.aaE=!1
$.aET=["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]
$.a9r=null
$.acM=!1
$.a9q=null
$.aaD=!1
$.a9m=null
$.aaC=!1
$.aEP=[$.akT]
$.aEO=[$.akT]
$.aEQ=[$.aET]})();(function lazyInitializers(){var x=a.lazyOld
x($,"aPJ","a4D",function(){return P.nO(H.a([],y.C),y.k)})
x($,"aPg","a4y",function(){return F.A_("_SimpleHtmlBase")})})()}
$__dart_deferred_initializers__["gBWbwrr9XS9BhZjrWhrDbe1ftoo="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_74.part.js.map
