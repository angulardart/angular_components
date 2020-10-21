self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var C,H,J,P={wu:function wu(d,e){this.a=d
this.$ti=e},
aa0:function(d,e,f,g){var x,w,v,u,t,s,r,q,p,o,n,m=null,l=e.length
if(l!==0){v=0
while(!0){if(!(v<l)){x=""
w=0
break}if(C.d.by(e,v)===64){x=C.d.b0(e,0,v)
w=v+1
break}++v}if(w<l&&C.d.by(e,w)===91){for(u=w,t=-1;u<l;++u){s=C.d.by(e,u)
if(s===37&&t<0){r=C.d.dz(e,"25",u+1)?u+2:u
t=u
u=r}else if(s===93)break}if(u===l)throw H.p(P.co("Invalid IPv6 host entry.",e,w))
q=t<0?u:t
P.a2y(e,w+1,q);++u
if(u!==l&&C.d.by(e,u)!==58)throw H.p(P.co("Invalid end of authority",e,u))}else u=w
while(!0){if(!(u<l)){p=m
break}if(C.d.by(e,u)===58){o=C.d.cw(e,u+1)
p=o.length!==0?P.fg(o,m):m
break}++u}n=C.d.b0(e,w,u)}else{p=m
n=p
x=""}return P.ar_(n,m,H.a(f.split("/"),y.S),p,g,d,x)}},W,G={
mA:function(d,e){var x,w=new G.Dk(E.S(d,e,1)),v=$.a9q
if(v==null)v=$.a9q=O.a0($.aEQ,null)
w.b=v
x=document.createElement("simple-html")
w.c=x
return w},
aMO:function(){return new G.KA(new G.R())},
a9o:function(d,e){var x,w=new G.Dj(E.S(d,e,1)),v=$.a9p
if(v==null)v=$.a9p=O.a0($.aEP,null)
w.b=v
x=document.createElement("simple-html-block")
w.c=x
return w},
aMN:function(){return new G.Kz(new G.R())},
aiW:function(){if($.aaF)return
$.aaF=!0
$.T.w(0,C.n8,new D.l("simple-html",G.aCG(),y.x))
$.T.w(0,C.n7,new D.l("simple-html-block",G.aCF(),y.X))
E.F()
V.dM()},
Dk:function Dk(d){var _=this
_.c=_.b=_.a=null
_.d=d},
KA:function KA(d){var _=this
_.c=_.b=_.a=null
_.d=d},
Dj:function Dj(d){var _=this
_.c=_.b=_.a=null
_.d=d},
Kz:function Kz(d){var _=this
_.c=_.b=_.a=null
_.d=d},
hT:function hT(d){this.a=d}},Y={Uj:function Uj(){}},R={k_:function k_(){this.a=0}},K,V,E={
aq1:function(){return C.hh},
aMM:function(){return new E.Ky(new G.R())},
av7:function(){if($.aaD)return
$.aaD=!0
$.T.w(0,C.n6,new D.l("simple-html-api",E.ahF(),y.V))
E.F()
K.d7()
D.cV()
A.awt()
F.axq()},
Di:function Di(d){var _=this
_.c=_.b=_.a=_.k4=_.k3=_.k2=_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
Ky:function Ky(d){var _=this
_.c=_.b=_.a=null
_.d=d}},M,Q,D,Z,O,A={
aMQ:function(){return new A.KC(new G.R())},
awt:function(){if($.acN)return
$.acN=!0
$.T.w(0,C.n9,new D.l("simple-html-example",A.akR(),y.s))
E.F()
G.aiW()},
Dm:function Dm(d){var _=this
_.c=_.b=_.a=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KC:function KC(d){var _=this
_.c=_.b=_.a=null
_.d=d}},T,L,N,U,X,B,S={lH:function lH(){}},F={
mv:function(d,e,f,g){var x=f==null?$.a4E():f
x=F.aar(x,E.i1(g,!1))
return new F.lG(e,d,new P.N(null,null,y.K),new R.aN(!1),new F.we(x))},
a6a:function(d,e,f,g){var x,w=f==null?$.a4E():f
w=F.aar(w,E.i1(g,!1))
x=y.i
w.h5("p",H.a(["class"],x))
w.h5("ul",H.a(["class"],x))
w.h5("li",H.a(["class"],x))
return new F.lF(e,d,new P.N(null,null,y.K),new R.aN(!1),new F.we(w))},
Yz:function(d,e){return new F.wv(!1,null,null,"Unsafe URI "+H.B(d)+" because "+e)},
XQ:function(d,e){return new F.vJ(!1,null,null,"Element "+H.B(d)+" was malformed: "+e)},
aat:function(d){var x,w,v=null
try{v=P.a2x(d)}catch(x){H.bc(x)
w=F.Yz(d,"Could not parse")
throw H.p(w)}return P.a6j().p1(v)},
aqO:function(d){var x=new F.Yd(P.nK(d,y.k))
x.Kl(d)
return x},
aar:function(d,e){var x=e?new F.Xs():F.aqO(d),w=new W.pU(H.a([],y.Q)),v=y.i
w.Fk("a",H.a(["class","href","rel","target","title"],v),x)
w.h5("b",H.a(["class"],v))
w.h5("br",H.a(["class"],v))
w.h5("em",H.a(["class"],v))
w.h5("i",H.a(["class"],v))
w.h5("span",H.a(["class"],v))
w.h5("strong",H.a(["class"],v))
return w},
lG:function lG(d,e,f,g,h){var _=this
_.f=d
_.a=e
_.b=null
_.c=f
_.d=g
_.e=h},
lF:function lF(d,e,f,g,h){var _=this
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
Yd:function Yd(d){this.a=d},
Yf:function Yf(){},
Ye:function Ye(d){this.a=d},
Xs:function Xs(){},
aMP:function(){return new F.KB(new G.R())},
axq:function(){if($.aaE)return
$.aaE=!0
$.T.w(0,C.nJ,new D.l("simple-html-custom-whitelist-example",F.akQ(),y.y))
E.F()
G.aiW()},
Dl:function Dl(d){var _=this
_.c=_.b=_.a=_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=_.f=_.e=null
_.d=d},
KB:function KB(d){var _=this
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
P.wu.prototype={
aP:function(d,e){return J.a1K(this.a,e)},
gb3:function(d){return J.bK(J.a1N(this.a))},
gM:function(d){return J.bS(this.a)},
R:function(d,e){throw H.p(P.aK("Cannot change unmodifiable set"))},
bC:function(d,e){throw H.p(P.aK("Cannot change unmodifiable set"))}}
F.lG.prototype={
gI2:function(d){var x=this.f,w=x.children
if(x.firstElementChild==null)x=null
else{x=new W.ob(x,w)
x=x.gdw(x)}return x}}
F.lF.prototype={
gI2:function(d){var x=this.f,w=x.children
if(x.firstElementChild==null)x=null
else{x=new W.ob(x,w)
x=x.gdw(x)}return x}}
F.Yg.prototype={
sh6:function(d){this.a.cL(new F.Yj(this,d))}}
F.wv.prototype={}
F.vJ.prototype={}
F.we.prototype={
fu:function(d){if(!this.a.fu(d))throw H.p(F.XQ(d,"prohibited element"))
return!0},
fg:function(d,e,f){var x,w
if(d.tagName.toLowerCase()==="a"&&e==="target"){x=d.hasAttribute("rel")
if(!x)throw H.p(F.XQ(d,"did not set rel attribute"))
w=d.getAttribute("rel")
if(!C.e.aP(H.a(w.split(" "),y.S),"noopener"))throw H.p(F.XQ(d,"did not set link type noopener (only "+w+")"))}if(!this.a.fg(d,e,f))throw H.p(F.XQ(d,"prohibited attribute "+e+" with value "+H.B(f)))
return!0},
$ifq:1}
F.Yd.prototype={
Kl:function(d){C.e.b2(this.a,new F.Yf())},
lc:function(d){var x,w,v,u=F.aat(d),t=null
try{t=J.an8(u)}catch(x){H.bc(x)
w=F.Yz(d,"Resolved URI "+H.B(u)+" had no origin")
throw H.p(w)}w=t
v=P.a6j()
if(!J.aa(w,v.glN(v))&&!this.NT(u))throw H.p(F.Yz(d,"Different origin and non-whitelisted URL"))
return!0},
NT:function(d){return C.e.cM(this.a,new F.Ye(d))}}
F.Xs.prototype={
lc:function(d){var x=F.aat(d)
if(!J.a1K(C.kx.a,x.ghx()))throw H.p(F.Yz(d,"URI scheme "+x.ghx()+" not allowed"))
return!0}}
G.Dk.prototype={
q:function(){var x=this.a2()
this.m(T.dJ(document,x))}}
G.KA.prototype={
q:function(){var x,w=this,v=G.mA(w,0)
w.b=v
x=v.c
v=F.mv(w.n(C.b,null),x,w.l(C.aF,null),null)
w.a=v
w.F(x)},
A:function(){this.b.j()},
G:function(){this.a.d.H()}}
G.Dj.prototype={
q:function(){var x=this.a2()
this.h(T.u(document,x))}}
G.Kz.prototype={
q:function(){var x,w=this,v=G.a9o(w,0)
w.b=v
x=v.c
v=F.a6a(w.n(C.b,null),x,w.l(C.aF,null),null)
w.a=v
w.F(x)},
A:function(){this.b.j()},
G:function(){this.a.d.H()}}
R.k_.prototype={
Zw:function(){return this.a++}}
A.Dm.prototype={
q:function(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i=this,h=null,g=i.a,f=i.a2(),e=document,d=T.d(e,f,"h2")
i.m(d)
T.b(d,"SimpleHTML with default URI whitelist")
x=T.d(e,f,"p")
i.m(x)
w=G.mA(i,3)
i.e=w
v=w.c
x.appendChild(v)
i.h(v)
w=i.d
u=w.a
w=w.b
t=F.mv(u.n(C.b,w),v,u.l(C.aF,w),h)
i.f=t
i.e.K(0,t)
s=T.d(e,f,"ul")
i.h(s)
r=T.d(e,s,"li")
i.m(r)
t=G.mA(i,6)
i.r=t
q=t.c
r.appendChild(q)
i.h(q)
t=F.mv(u.n(C.b,w),q,u.l(C.aF,w),h)
i.x=t
i.r.K(0,t)
p=T.d(e,s,"li")
i.m(p)
t=G.mA(i,8)
i.y=t
o=t.c
p.appendChild(o)
i.h(o)
t=F.mv(u.n(C.b,w),o,u.l(C.aF,w),h)
i.z=t
i.y.K(0,t)
n=T.d(e,f,"p")
i.m(n)
T.b(n,"The following message is removed due to disallowed HTML: [")
t=G.mA(i,11)
i.Q=t
m=t.c
n.appendChild(m)
i.h(m)
t=F.mv(u.n(C.b,w),m,u.l(C.aF,w),h)
i.ch=t
i.Q.K(0,t)
T.b(n,"]")
l=T.d(e,f,"p")
i.m(l)
t=G.mA(i,14)
i.cx=t
k=t.c
l.appendChild(k)
i.O(k,"click-target")
i.h(k)
t=F.mv(u.n(C.b,w),k,u.l(C.aF,w),h)
i.cy=t
i.cx.K(0,t)
t=G.a9o(i,15)
i.db=t
j=t.c
f.appendChild(j)
i.h(j)
w=F.a6a(u.n(C.b,w),j,u.l(C.aF,w),h)
i.dx=w
i.db.K(0,w)
w=i.cy.c
i.bo(H.a([new P.e(w,H.m(w).i("e<1>")).D(i.ad(g.gZv(),y.p))],y.a))},
A:function(){var x,w,v,u,t,s,r,q,p,o=this,n=null,m=o.a
m.toString
x=y.M
w=T.aR('I <b>love</b> using <span class="highlight">HTML</span>.',n,"SimpleHtmlExampleMessages_messageWithFormatting",H.a(["<b>","</b>",'<span class="highlight">',"</span>"],x),n)
v=o.dy
if(v!=w){o.f.sh6(w)
o.dy=w
u=!0}else u=!1
if(u)o.e.d.st(1)
t=T.aR('Please consult our <a href="localpage.html?param=1#test_fragment">docs</a>.',n,"SimpleHtmlExampleMessages_messageLink",H.a(['<a href="localpage.html?param=1#test_fragment">',"</a>"],x),n)
v=o.fr
if(v!=t){o.x.sh6(t)
o.fr=t
u=!0}else u=!1
if(u)o.r.d.st(1)
s=T.aR('Alternatively, open our <a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">docs</a> in a new window.',n,"SimpleHtmlExampleMessages_messageWithLinkInNewTab",H.a(['<a href="localpage.html?param=1#test_fragment" target="_blank" rel="noopener">',"</a>"],x),n)
v=o.fx
if(v!=s){o.z.sh6(s)
o.fx=s
u=!0}else u=!1
if(u)o.y.d.st(1)
r=T.aR('Please consult my <a href="https://hecuba.org">suspicious website</a>.',n,"SimpleHtmlExampleMessages_messageWithDisallowedHtml",H.a(['<a href="https://hecuba.org">',"</a>"],x),n)
v=o.fy
if(v!=r){o.ch.sh6(r)
o.fy=r
u=!0}else u=!1
if(u)o.Q.d.st(1)
v=m.a
q=T.aR('You <a class="trigger">clicked here</a> '+v+" times.",n,"SimpleHtmlExampleMessages_messageWithClickHandler",H.a([v,'<a class="trigger">',"</a>"],x),n)
v=o.go
if(v!=q){o.cy.sh6(q)
o.go=q
u=!0}else u=!1
if(u)o.cx.d.st(1)
p=T.aR("            A list!\n\n            <ul>\n              <li>\n                Here's an <b>element</b>.\n              </li>\n              <li>\n                And here's another.\n              </li>\n            </ul>\n\n            And that's the end of the list.",n,"SimpleHtmlExampleMessages_blockMessage",H.a(["<b>","</b>","<ul>","</ul>","<li>","</li>"],x),n)
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
A.KC.prototype={
q:function(){var x,w=this,v=new A.Dm(E.S(w,0,3)),u=$.a9s
if(u==null)u=$.a9s=O.a0($.aER,null)
v.b=u
x=document.createElement("simple-html-example")
v.c=x
w.b=v
w.a=new R.k_()
w.F(x)}}
S.lH.prototype={}
F.Dl.prototype={
q:function(){var x,w,v,u,t,s,r,q,p,o,n=this,m="(removed)",l=n.a2(),k=document
T.b(T.d(k,l,"h2"),"SimpleHTML with a custom URI whitelist")
x=T.d(k,l,"ul")
w=T.d(k,x,"li")
v=G.mA(n,4)
n.e=v
u=v.c
w.appendChild(u)
v=n.d
t=v.a
v=v.b
s=F.mv(t.n(C.b,v),u,t.l(C.aF,v),null)
n.f=s
n.e.K(0,s)
r=T.d(k,x,"li")
s=G.mA(n,6)
n.r=s
q=s.c
r.appendChild(q)
s=F.mv(t.n(C.b,v),q,t.l(C.aF,v),null)
n.x=s
n.r.K(0,s)
T.b(r,m)
p=T.d(k,x,"li")
s=G.mA(n,9)
n.y=s
o=s.c
p.appendChild(o)
v=F.mv(t.n(C.b,v),o,t.l(C.aF,v),null)
n.z=v
n.y.K(0,v)
T.b(p,m)},
A:function(){var x,w,v,u,t,s=this,r="</a>"
s.a.toString
x=C.c6.qQ('<a href="'+H.B(P.qQ(C.cn,"https://wordpress.org/plugins/amp/",C.aI,!1))+'">',r)
w=s.Q
if(w!=x){s.f.sh6(x)
s.Q=x
v=!0}else v=!1
if(v)s.e.d.st(1)
u=C.c6.qQ('<a href="'+H.B(P.qQ(C.cn,"https://wordpress.org/plugins/malware/",C.aI,!1))+'">',r)
w=s.ch
if(w!=u){s.x.sh6(u)
s.ch=u
v=!0}else v=!1
if(v)s.r.d.st(1)
t=C.c6.qQ('<a href="'+H.B(P.qQ(C.cn,"javascript:alert('!')",C.aI,!1))+'">',r)
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
F.KB.prototype={
q:function(){var x,w=this,v=new F.Dl(E.S(w,0,3)),u=$.a9r
if(u==null)u=$.a9r=O.bG(C.a,null)
v.b=u
x=document.createElement("simple-html-custom-whitelist-example")
v.c=x
w.b=v
w.a=new S.lH()
w.F(x)},
P:function(d,e,f){var x
if(d===C.aF&&0===e){x=this.e
return x==null?this.e=P.nK(H.a([P.aa0("https","developers.google.com","",null),P.aa0("https","wordpress.org","plugins/amp/",null)],y.C),y.k):x}return f}}
Y.Uj.prototype={
qQ:function(d,e){return T.aR("Visit "+d+"this site"+d+"!",null,"SimpleHtmlCustomWhitelistExampleMessages_linkTo",H.a([d,e],y.M),null)}}
G.hT.prototype={}
E.Di.prototype={
gmi:function(){var x=this.r
return x==null?this.r=document:x},
gxp:function(){var x=this.y
return x==null?this.y=window:x},
gmj:function(){var x,w=this,v=w.z
if(v==null){v=w.d
x=v.a
v=v.b
v=T.bx(x.l(C.b,v),x.l(C.D,v),x.n(C.f,v),w.gxp())
w.z=v}return v},
gxd:function(){var x,w=this,v=w.Q
if(v==null){v=w.d
v=v.a.n(C.U,v.b)
x=w.gmj()
v=w.Q=new O.bh(v,x)}return v},
gpA:function(){var x=this,w=x.ch
return w==null?x.ch=new K.bi(x.gmi(),x.gmj(),P.bu(null,y.f)):w},
gKg:function(){var x=this.cx
if(x==null){x=this.d
x=T.bB(x.a.n(C.f,x.b))
this.cx=x}return x},
gu_:function(){var x=this.cy
if(x==null){x=this.d
x=G.bF(x.a.l(C.t,x.b))
this.cy=x}return x},
gDL:function(){var x=this,w=x.db
if(w==null){w=x.d
w=G.bI(x.gmi(),w.a.l(C.u,w.b))
x.db=w}return w},
gDM:function(){var x=this,w=x.dx
if(w==null){w=x.d
w=G.bz(x.gu_(),x.gDL(),w.a.l(C.r,w.b))
x.dx=w}return w},
gu0:function(){var x=this.dy
return x==null?this.dy=!0:x},
gDN:function(){var x=this.fr
return x==null?this.fr=!0:x},
gxj:function(){var x=this.fy
if(x==null){x=this.gmi()
x=this.fy=new R.bk(x.querySelector("head"),x)}return x},
gxq:function(){var x=this.go
return x==null?this.go=X.bE():x},
gxi:function(){var x=this,w=x.id
return w==null?x.id=K.bD(x.gxj(),x.gDM(),x.gu_(),x.gpA(),x.gmj(),x.gxd(),x.gu0(),x.gDN(),x.gxq()):w},
gKi:function(){var x,w,v,u,t=this,s=t.k1
if(s==null){s=t.d
x=s.a
s=s.b
w=x.n(C.f,s)
v=t.gu0()
u=t.gxi()
x.l(C.k,s)
s=t.k1=new X.bg(v,w,u)}return s},
q:function(){var x=this,w=x.a2(),v=K.cH(x,0)
x.e=v
w.appendChild(v.c)
v=x.d
v=v.a.n(C.a9,v.b)
v=new X.cb(v,!J.bA(window.location.href,"enableLatencyCharts=false"))
x.f=v
x.e.K(0,v)},
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
return x==null?w.k3=new K.bp(w.gpA()):x}}return f},
A:function(){var x=this,w=x.a.a,v=x.k4
if(v!==w)x.k4=x.f.a=w
x.e.j()},
G:function(){this.e.k()}}
E.Ky.prototype={
q:function(){var x,w,v,u=this,t=new E.Di(E.S(u,0,3)),s=$.a9n
if(s==null)s=$.a9n=O.bG(C.a,null)
t.b=s
x=document.createElement("simple-html-api")
t.c=x
u.b=t
t=y.P
t=H.a([new D.kL("README","angular_components/lib/simple_html/README.md",X.h('<h1>Simple HTML</h1>\n<p>Displays low-trust HTML with strict and flexible sanitization.</p>\n<p>This component is focused on displaying localized or otherwise partially-trusted\nHTML in the following use cases:</p>\n<ul>\n<li>Light formatting (bold, italic, newlines).</li>\n<li>Links to external domains (with a customisable whitelist).</li>\n<li>Arbitrary click handlers on substrings within the text.</li>\n</ul>\n<p>Mixing these features with text that cannot appear verbatim in the template (due\nto, for example, use of the <code>Intl</code> library for localization) is otherwise\ndifficult. This component is the recommended alternative to calling methods like\n<a href="https://pub.dev/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\nwhen inserting HTML into the DOM.</p>\n<h2>Usage</h2>\n<p>Using the <code>&lt;simple-html&gt;</code> and <code>&lt;simple-html-block&gt;</code> components is generally\nrecommended in the following cases:</p>\n<ul>\n<li>Displaying\n<a href="https://en.wikipedia.org/wiki/Internationalization_and_localization">i18n</a>\nmessages that need to contain light text formatting (such as bold, italics,\nlists, or custom styles), links to URLs outside the current app, or custom\nclick handlers.</li>\n<li>Displaying HTML generated outside of a template (e.g. HTML that is built\nserver-side but displayed client-side).</li>\n</ul>\n<p>The alternatives include:</p>\n<ul>\n<li>Standard Angular interpolation with <code>{{</code> ... <code>}}</code>.\n<ul>\n<li>This is the fastest and safest option and should always be preferred if\nyou do not need any sort of mark-up inside the string.</li>\n</ul>\n</li>\n<li>Using the <code>[innerHtml]</code> directive with a string argument.\n<ul>\n<li>This is secure but very strict; only very limited tags are allowed.</li>\n<li>The behaviour in case of mistakes may be surprising. (For example,\ninvalid links are silently removed.)</li>\n<li>The permitted elements and attributes are defined by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SimpleNodeValidator</a>\nand the permitted URLs by the\n<a href="https://raw.githubusercontent.com/dart-lang/sdk/master/sdk/lib/html/dart2js/html_dart2js.dart">_SameOriginUriPolicy</a>.</li>\n</ul>\n</li>\n<li>Using the <code>[safeInnerHtml]</code> directive, or the <code>[innerHtml]</code> directive with a\n<code>SafeHtml</code> argument generated by <code>bypassSecurityTrustHtml()</code>.\n<ul>\n<li>This is generally not secure, since absolutely all tags are allowed and\nthere is no further line of defense between you and\n<a href="https://en.wikipedia.org/wiki/Cross-site_scripting">XSS</a>. This should\nbe used only if there is no alternative.</li>\n</ul>\n</li>\n</ul>\n<h2>Motivating example</h2>\n<p>You have a message for translation that contains simple HTML tags and can\'t\neasily be broken into separate parts. A typical example would be an inline link:</p>\n<pre><code class="language-html">Please see our &lt;a href="https://support.google.com"&gt;Help Center&lt;/a&gt; for more information.\n</code></pre>\n<p>or some light formatting</p>\n<pre><code class="language-html">This is the &lt;b&gt;best&lt;/b&gt; feature in Google history!\n</code></pre>\n<p>You have a few options:</p>\n<ol>\n<li>\n<p>Include the message in the template in the normal way, <code>{{myMessage}}</code>. This\nwon\'t work because the tags are stripped out by the sanitizer \u2014 the text\nappears, but the links and bold don\'t work.</p>\n</li>\n<li>\n<p>Move the tags into the template and split one message into three:</p>\n<pre><code class="language-html">{{pleaseSeeMessage}}&lt;a href="https://support.google.com"&gt;{{helpCenterMessage}}&lt;/a&gt;{{forMoreInformationMessage}}\n</code></pre>\n<p>This is a problem for localization because the word order is very different\nin different languages; for example, in some languages the link would\nnaturally be at the end of the sentence. This is also problematic for\ntranslators who have to translate sentence fragments.</p>\n</li>\n<li>\n<p>Define a "micro-language" inside the message and parse each message on the\nway to the template. For example, you could include sentinel values in the\nmessage and then decompose the string with some custom code:</p>\n<pre><code>List&lt;String&gt; get messageFragments =&gt; someMessage(_sentinel, _sentinel).split(_sentinel)\n</code></pre>\n<p>Then refer to the fragments inside the template:</p>\n<pre><code class="language-html">{{fragments[0]}} &lt;a href="https://support.google.com"&gt;{{fragments[1]}}&lt;/a&gt; {{fragments[2]}}\n</code></pre>\n<p>This becomes quite complex and error-prone if the message includes more than\na single tag, and also requires explicit handling and delegation for every\nmessage.</p>\n</li>\n<li>\n<p>Include the message straight into the DOM using the <code>innerHtml</code> directive:</p>\n<pre><code class="language-html">&lt;div [innerHtml]="seeHelpCenterMessage"&gt;\n</code></pre>\n<p>If <code>seeHelpCenterMessage</code> is a plain string, it will be strictly sanitized\nand disallowed elements silently removed. To work around this,\n<code>seeHelpCenterMessage</code> may instead return a\n<a href="https://pub.dev/documentation/angular/latest/angular.security/SafeHtml-class.html"><code>SafeHtml</code></a>\nobject. This object can be constructed by calling\n<a href="https://pub.dev/documentation/angular/latest/angular.security/DomSanitizationService/bypassSecurityTrustHtml.html"><code>bypassSecurityTrustHtml()</code></a>\non the string. However, this is very dangerous because it disables <em>all</em>\nsanitization and allows all tags (even <code>&lt;script&gt;</code>). If the string\naccidentally contains user-controlled data, or the translator made a mistake\nand included a dubious tag (such as <code>&lt;script&gt;</code>) in their translation, it\nwould also be placed straight into the DOM and open up the application to\nsevere security risks such as XSS.</p>\n</li>\n</ol>\n<p><code>&lt;simple-html&gt;</code> addresses many of these issues.</p>\n<h2>Features</h2>\n<p>The <code>&lt;simple-html&gt;</code> component is an inline element that allows you the\nflexibility to include basic text elements, such as bold, span, and links, while\nretaining very strong sanitization for other tags and attributes. It also\nsimplifies the code because there is no need to wrap the message in a <code>SafeHtml</code>\nobject; you can just use the message directly.</p>\n<p><em>Before:</em></p>\n<pre><code class="language-dart">MyComponent {\n  SafeHtml get myMessage =&gt; _sanitizer.bypassSecurityTrustHtml(messages.someMessage);\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;span [innerHtml]="myMessage"&gt;&lt;/span&gt; &lt;!-- Uh-oh, XSS risk. --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p><em>Now:</em></p>\n<pre><code class="language-dart">MyComponent {\n  // No code required!\n}\n</code></pre>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html [contents]="messages.someMessage"&gt;&lt;/simple-html&gt; &lt;!-- No XSS risk --&gt;\n&lt;/my-template&gt;\n</code></pre>\n<p>The <code>&lt;simple-html-block&gt;</code> component behaves similarly but is a block-level\nelement that can contain further block-level elements such as <code>&lt;ul&gt;</code>.</p>\n<h3>Atomic updates</h3>\n<p>To simplify debugging, any unsupported HTML will blank the entire component and\nprint a loud debug message. This makes it less likely that you overlook these\nerrors in testing.</p>\n<h3>Supported tags</h3>\n<p>See the\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">component\'s documentation</a>\nfor the exact specification of what is supported. A general overview is:</p>\n<ul>\n<li><code>&lt;simple-html&gt;</code> supports the following safe inline elements:\n<ul>\n<li>Basic text formatting: <code>&lt;b&gt;</code>, <code>&lt;strong&gt;</code>, <code>&lt;i&gt;</code>, <code>&lt;em&gt;</code>.</li>\n<li>Line breaks: <code>&lt;br&gt;</code>.</li>\n<li>Text grouping: <code>&lt;span&gt;</code>.</li>\n<li>Links: <code>&lt;a href="..."&gt;</code> provided the destination matches the current\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">origin</a>, points to\ncertain permitted URIs such as the Help Center, or uses the\n<code>doNotVerifyUrlDestinations</code> flag; see\n(<a href="#uri-whitelisting">URI whitelisting</a>).\n<ul>\n<li>The <code>rel</code> attributes are permitted.</li>\n<li>The <code>target</code> attribute is permitted provided <code>rel="noopener"</code> is\nset.</li>\n<li>The <code>title</code> attribute is permitted.</li>\n</ul>\n</li>\n</ul>\n</li>\n<li><code>&lt;simple-html-block&gt;</code> supports all of the above and the following safe block\nelements:\n<ul>\n<li>Unordered lists: <code>&lt;ul&gt;</code> and <code>&lt;li&gt;</code>.</li>\n<li>Paragraphs: <code>&lt;p&gt;</code>.</li>\n</ul>\n</li>\n</ul>\n<p>The <code>class</code> attribute is permitted by all elements.</p>\n<h3>URI whitelisting {#uri-whitelisting}</h3>\n<p>By default, only links with the\n<a href="https://en.wikipedia.org/wiki/Same-origin_policy">same origin</a> as the host page\nas permitted.</p>\n<p>Additional paths can be permitted through an optional Angular dependency. See\nthe\n<a href="https://github.com/dart-lang/angular_components/blob/master/lib/simple_html/simple_html.dart">simpleHtmlUriWhitelist</a>\ntoken for details.</p>\n<h4>Allowing external URIs without a whitelist</h4>\n<p>There are cases where you can not use a whitelist:</p>\n<ul>\n<li>when exposing a whitelist through client code is not acceptable, or</li>\n<li>the whitelist is not fixed</li>\n</ul>\n<p>When the URIs come from a <em>safe</em> source, such as internally sourced URIs, you\ncan consider enabling the <code>doNotVerifyUrlDestinations</code> flag. This will allow any\nURI with the <code>http</code>, <code>https</code> or <code>mailto</code> scheme to be inserted, and should\ntherefore be used with caution.</p>\n<p>For example:</p>\n<pre><code class="language-html">&lt;my-template&gt;\n  &lt;simple-html doNotVerifyUrlDestinations\n               [contents]="internalMessages.someMessage"&gt;&lt;/simple-html&gt;\n&lt;/my-template&gt;\n</code></pre>\n<h3>Custom click handling</h3>\n<p>The component provides a <code>(trigger)</code> output, which is fired whenever an <code>&lt;a&gt;</code>\nelement with the CSS class <code>trigger</code> is clicked by the user. This is intended\nfor introducing custom click handlers to specified portions of the text. A\nsimple example, firing an Analytics event when a certain word is clicked, might\ndefine a message and handler in the component:</p>\n<pre><code class="language-dart">String get someMessage =&gt; \'Click &lt;a class="trigger"&gt;here&lt;/a&gt;.\';\n\nvoid recordAnalyticsEvent =&gt; _analytics.fire();\n</code></pre>\n<p>and then include it in the template:</p>\n<pre><code class="language-html">&lt;simple-html [contents]="someMessage"\n             (trigger)="recordAnalyticsEvent()"&gt;&lt;/simple-html&gt;\n</code></pre>\n<p>By default, the normal behaviour of the link also occurs, such as navigation. So\nif a user clicks "here" in this message</p>\n<pre><code class="language-html">Click &lt;a href="//example.com" class="trigger" (trigger)="myTrigger()"&gt;here&lt;/a&gt;\n</code></pre>\n<p>then they will navigate to example.com <em>and</em> <code>myTrigger</code> will be executed.</p>\n<p>The trigger definition can also refer to the original Angular\n<a href="https://webdev.dartlang.org/angular/guide/template-syntax#event-and-event-handling-statements"><code>$event</code></a>.\nThis can be useful for more advanced features such as:</p>\n<ul>\n<li>Selectively preventing the default behaviour (such as navigation) by calling\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault"><code>$event.preventDefault</code></a>.</li>\n<li>Having multiple <code>trigger</code> elements with different behaviour in the same\nmessage. Which element was clicked can be identified by reading the\n<a href="https://developer.mozilla.org/en-US/docs/Web/API/Event/target"><code>$event.target</code></a>\nfield.</li>\n</ul>\n<h3>Limitations</h3>\n<p>The following is not yet supported:</p>\n<ul>\n<li>Other elements and attributes that are probably safe but are not yet in\ndemand (such as <code>blockquote</code>).</li>\n<li>More dangerous cases (such as setting the URL of an iframe) must still be\ndone using <code>bypassSecurity*</code> methods. (But preferably don\'t do this at all.)</li>\n</ul>\n<h2>Migration</h2>\n<p>Migration from an existing <code>bypassSecurityTrustHtml()</code> solution is generally\nstraightforward. Basic steps:</p>\n<ol>\n<li>Import the Dart library\n<code>package:angular_components/simple_html/simple_html.dart</code> in your component\nfile.</li>\n<li>Add the <code>SimpleHtmlComponent</code> to your\n<a href="https://pub.dev/documentation/angular_compiler/latest/v1_src_metadata_directives/Component-class.html">@Component</a>\'s\ndirective list.</li>\n<li>For each message that previously used <code>bypassSecurityTrustHtml()</code>, remove\nthat call and use the string directly.</li>\n<li>In your template file, bind the message with either:\n<ul>\n<li><code>&lt;simple-html [contents]="msg"&gt;&lt;/simple-html&gt;</code> rather than <code>&lt;span [innerHtml]="msg"&gt;&lt;/span&gt;</code> (if only inline elements are required).</li>\n<li><code>&lt;simple-html-block [contents]="msg"&gt;&lt;/simple-html-block&gt;</code> rather than\n<code>&lt;div [innerHtml]="msg"&gt;&lt;/div&gt;</code> (if inline and block elements are\nrequired).</li>\n</ul>\n</li>\n<li>Verify that it works! See <a href="#testing"><em>Testing</em></a>.</li>\n<li>Clean up unused dependencies (e.g. remove the <code>DomSanitizer</code> if your\ncomponent no longer needs it).</li>\n<li>If possible, prevent future usage of the unsafe methods by adding a\npresubmit check.</li>\n</ol>\n<p>Remember that <code>&lt;simple-html&gt;</code> is an\n<a href="https://developer.mozilla.org/en-US/docs/Web/CSS/display">inline-block</a> element\nso, if you need other display types, you will need to apply a custom CSS class\nor wrap it inside another element. Likewise <code>&lt;simple-html-block&gt;</code> is a\nblock-level element and therefore should not be placed inside inline elements.</p>\n<h3>Testing</h3>\n<p>The easiest way to debug quickly is to test that the text appears correctly in a\nlocal build of your application. Due to SimpleHtml\'s atomic updates, you will\neither see the message in full or no message at all, and in the latter case a\nhelpful debug message will be printed to the browser console.</p>\n<h3>Troubleshooting</h3>\n<p>Some common issues and remedies include:</p>\n<ul>\n<li><strong>The message appears empty</strong>\n<ul>\n<li>Check the console for error messages. If your HTML was rejected, you\nshould see a log message at <code>SHOUT</code> severity describing the problem.</li>\n</ul>\n</li>\n</ul>\n')),new D.b5("SimpleHtmlComponent",!1,"","simple-html","","angular_components/lib/simple_html/simple_html.dart",X.h('<p>A component that allows the inclusion of some limited HTML in a safe way.\nThis is ideal if you have internationalized messages with simple inline\nHTML. It is generally much preferable to using <code>bypassSecurityTrustHtml</code>,\nwhich disables all sanitization.</p>\n<p>The specific subset of HTML that is permitted is:</p>\n<ul>\n<li><code>&lt;a&gt;</code> with <code>href</code> pointing to a same-origin URL or a permitted external\n  URL (see <code>simpleHtmlUriWhitelist</code>) and (optionally) <code>class</code>, <code>rel</code>, or\n  <code>target</code> attributes. If <code>target</code> is set, <code>rel</code> must also be set and\n  must contain <code>noopener</code> (see\n  <a href="https://mathiasbynens.github.io/rel-noopener/">https://mathiasbynens.github.io/rel-noopener/</a> for background).</li>\n<li><code>&lt;span&gt;</code> <code>&lt;b&gt;</code>, <code>&lt;br&gt;</code>, <code>&lt;em&gt;</code>, and <code>&lt;i&gt;</code> with (optionally) a <code>class</code>\n  attribute.</li>\n</ul>\n<p>Note that any styles applied with the class attribute will need to be\nannotated with <code>::ng-deep</code> (or equivalent mechanism) in order to actually\nreach the content elements.</p>\n<p>Prohibited HTML (including invalid elements, attributes, or URLs) will blank\nthe entire component and print a loud log message.</p>\n<p>If the attribute doNotVerifyUrlDestinations is present, external URLs will\nnot be verified, except for their URI scheme. This is flag should only ever\nbe used for URLs that come from a safe source, such as internal\ndocumentation.</p>\n<p>If the <code>(trigger)</code> output is bound, anchor elements with the sentinel class\n"trigger" will send an event to this output. The event is the original\nAngular <code>$event</code>.</p>\n'),H.a([new D.j("contents","","String",X.h("<p>HTML to display in the component.</p>\n"),!1,"")],t),H.a([new D.j("trigger","","Stream<UIEvent>",X.h("<p>Propagates events from internal anchor elements with the class trigger\nsending the original angular event.</p>\n"),!1,"")],t))],y.c)
w=H.a([new R.aJ(C.h9,"SimpleHtmlExampleComponent","simple_html_example/lib/basic_example/simple_html_example.dart"),new R.aJ(C.hv,"SimpleHtmlCustomWhitelistExampleComponent","simple_html_example/lib/custom_whitelist_example/simple_html_custom_whitelist_example.dart")],y.D)
v=y.R
u.a=new G.hT(R.cQ(H.a([],y.i),w,t,P.aW(v,v),!0))
u.F(x)}}
var z=a.updateTypes(["~()","f<lG*>*()","f<lF*>*()","f<k_*>*()","f<lH*>*()","f<hT*>*()"])
F.Yj.prototype={
$0:function(){var x,w,v,u=this.a
if(u.b==null)u.b=u.gI2(u)
u.d.H()
w=u.b
if(w==null)return
try{J.anp(w,this.b,u.e)}catch(v){x=H.bc(v)
if(x instanceof F.wv)$.a4z().jP(C.ds,"simple-html used untrusted URI: "+H.B(x),x,null)
else if(x instanceof F.vJ)$.a4z().jP(C.ds,"simple-html used malformed element: "+H.B(x),x,null)
else throw v}u.a.du(new F.Yi(u))},
$S:0}
F.Yi.prototype={
$0:function(){var x=this.a,w=y.h
new H.bj(new W.fu(x.b.querySelectorAll("a.trigger"),w),new F.Yh(x),w.i("bj<X.E,be<W*>*>")).b2(0,H.dy(x.d.gFg(),y.O))},
$S:0}
F.Yh.prototype={
$1:function(d){var x=J.an6(d),w=this.a.c
return W.cA(x.a,x.b,w.giA(w),!1,x.$ti.c)},
$S:214}
F.Yf.prototype={
$1:function(d){var x=d.gd1(d).length===0||C.d.jk(d.gd1(d),"/"),w="Whitelisted URIs with a path must end with a slash, which "+d.N(0)+" does not"
if(!x)H.a_(P.cM(N.asf(w,null)))
return null},
$S:215}
F.Ye.prototype={
$1:function(d){var x=this.a
return d.glN(d)===x.glN(x)&&C.d.ca(x.gd1(x),d.gd1(d))},
$S:216};(function installTearOffs(){var x=a._static_0,w=a._instance_0u
x(G,"aCG","aMO",1)
x(G,"aCF","aMN",2)
w(R.k_.prototype,"gZv","Zw",0)
x(A,"akR","aMQ",3)
x(F,"akQ","aMP",4)
x(E,"ahF","aMM",5)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(P.wu,P.qK)
w(P.y,[F.Yg,F.we,F.Yd,F.Xs,R.k_,S.lH,Y.Uj,G.hT])
w(F.Yg,[F.lG,F.lF])
w(H.bq,[F.Yj,F.Yi,F.Yh,F.Yf,F.Ye])
w(P.f0,[F.wv,F.vJ])
w(E.bn,[G.Dk,G.Dj,A.Dm,F.Dl,E.Di])
w(G.f,[G.KA,G.Kz,A.KC,F.KB,E.Ky])})()
H.ak(b.typeUniverse,JSON.parse('{"al":"v","ax":"v","ap":"ae","am":"o","aB":"o","aD":"o","an":"G","ao":"G","at":"I","ay":"I","aq":"A","aA":"A","aG":"O","aF":"a3","aE":"a9","av":"V","aw":"ac","aC":"W","az":"ag","au":"af","as":"ah","ar":"a1","wu":{"cx":["1"],"fs":["1"],"Z":["1"],"M":["1"],"cx.E":"1"},"wv":{"cn":[]},"vJ":{"cn":[]},"we":{"fq":[]},"Dk":{"k":[],"i":[]},"KA":{"f":["lG*"],"i":[],"f.T":"lG*"},"Dj":{"k":[],"i":[]},"Kz":{"f":["lF*"],"i":[],"f.T":"lF*"},"Dm":{"k":[],"i":[]},"KC":{"f":["k_*"],"i":[],"f.T":"k_*"},"Dl":{"k":[],"i":[]},"KB":{"f":["lH*"],"i":[],"f.T":"lH*"},"Di":{"k":[],"i":[]},"Ky":{"f":["hT*"],"i":[],"f.T":"hT*"}}'))
0
var y=(function rtii(){var x=H.K
return{V:x("l<hT*>"),X:x("l<lF*>"),x:x("l<lG*>"),y:x("l<lH*>"),s:x("l<k_*>"),Q:x("q<fq>"),S:x("q<t>"),P:x("q<j*>"),D:x("q<aJ*>"),c:x("q<d_*>"),M:x("q<y*>"),a:x("q<be<~>*>"),i:x("q<t*>"),C:x("q<iI*>"),h:x("fu<aT*>"),K:x("N<V*>"),f:x("D<t*>*"),O:x("W*"),R:x("t*"),p:x("V*"),k:x("iI*")}})();(function constants(){var x=a.makeConstList
C.c6=new Y.Uj()
C.h9=new D.l("simple-html-example",A.akR(),y.s)
C.hh=new D.l("simple-html-api",E.ahF(),y.V)
C.hv=new D.l("simple-html-custom-whitelist-example",F.akQ(),y.y)
C.cn=H.a(x([0,0,65498,45055,65535,34815,65534,18431]),H.K("q<H*>"))
C.aF=new L.dd("simpleHtmlUriWhitelist",H.K("dd<D<iI*>*>"))
C.k0=H.a(x(["http","https","mailto"]),y.i)
C.kj=new H.cX(3,{http:null,https:null,mailto:null},C.k0,H.K("cX<t*,U>"))
C.kx=new P.wu(C.kj,H.K("wu<t*>"))
C.n6=H.C("hT")
C.n7=H.C("lF")
C.n8=H.C("lG")
C.n9=H.C("k_")
C.nJ=H.C("lH")})();(function staticFields(){$.akU=["._nghost-%ID%  a{color:#3367d6;cursor:pointer;text-decoration:none}._nghost-%ID%  a:visited{color:#673ab7}._nghost-%ID%  a:active{color:#c53929}"]
$.a9q=null
$.a9p=null
$.aaF=!1
$.aEU=["._nghost-%ID%  .highlight{color:#f11;font-variant:small-caps}"]
$.a9s=null
$.acN=!1
$.a9r=null
$.aaE=!1
$.a9n=null
$.aaD=!1
$.aEQ=[$.akU]
$.aEP=[$.akU]
$.aER=[$.aEU]})();(function lazyInitializers(){var x=a.lazyOld
x($,"aPK","a4E",function(){return P.nK(H.a([],y.C),y.k)})
x($,"aPh","a4z",function(){return F.zY("_SimpleHtmlBase")})})()}
$__dart_deferred_initializers__["MTleaxkmwh5pyKkzyiLG87czRrQ="] = $__dart_deferred_initializers__.current
//# sourceMappingURL=main.dart.js_74.part.js.map
