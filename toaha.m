% save this m-file "toaha.m" inside the subfolder "demos"

addpath('../ddebiftool/','../ddebiftool_utilities/'); 
pp_sys = @(x,p)[...
p(1)*x(1,1) - p(2)*x(1,1).*x(1,2) - p(3)*x(1,1).*x(2,1) - p(6);
p(4)*x(1,1).*x(2,1) - p(5)*x(2,1)-p(7)];
funcs = set_funcs('sys_rhs',pp_sys,'sys_tau',@()[8]);

parbd = {'min_bound',[8,0],'max_bound',[8,15],'max_step',[8,0.05]};
[br,success] = SetupStst(funcs,...
    'parameter',[3.50 0.04 1.00 0.05 0.30 0.02 0.01 0.00],...
'x',[6.00; 3.00],'contpar',8,'step',0.02, parbd{:})

figure(1); clf;
br.method.continuation.plot = 1;
[br,s,f,r] = br_contn(funcs,br,300);
ylim([5,7]); set(gca,'FontSize',20);

figure(2); clf;
br = br_stabl(funcs,br,0,1);
[xm,ym] = df_measr(0,br);
br_splot(br,xm,ym);
ylim([5,7]); set(gca,'FontSize',20); 

br.method.stability.minimal_real_part = -2;
nunst = GetStability(br);
ind_hopf = find(abs(diff(nunst))==2)

[br_hopf1,success] = SetupHopf(funcs,br,ind_hopf(1))

[br_hopf2,success] = SetupHopf(funcs,br,ind_hopf(2))
[br_hopf3,success] = SetupHopf(funcs,br,ind_hopf(3))
[br_hopf4,success] = SetupHopf(funcs,br,ind_hopf(4))
[br_hopf5,success] = SetupHopf(funcs,br,ind_hopf(5))

[br_hopf5,success] = SetupHopf(funcs,br,ind_hopf(5),...
    'excludefreqs',br_hopf4.point(1).omega)

[br_psol3,success] = SetupPsol(funcs,br,ind_hopf(3))

br_psol3.method.continuation.plot = 0;
[br_psol3,s,f,r] = br_contn(funcs,br_psol3,60);
br_psol3 = br_stabl(funcs,br_psol3,0,1);

xm_psol=xm;
ym_psol.field='profile';
ym_psol.subfield='';
ym_psol.row=1;
ym_psol.col='all';
ym_psol.func='max';

figure(3); clf; hold on;
br_splot(br,xm,ym);
br_splot(br_psol3,xm_psol,ym_psol);
axis([6.5 9.5 0 45]); set(gca,'FontSize',20);

nunst_psol3 = GetStability(br_psol3,'exclude_trivial',true);
ind_pd = find(abs(diff(nunst_psol3))==1,1,'first')
[per2,success] = DoublePsol(funcs,br_psol3,ind_pd)

figure(4); clf; hold on;
per2.method.continuation.plot = 0;
[per2,s,f,r] = br_contn(funcs,per2,45);
per2 = br_stabl(funcs,per2,0,1);
br_splot(br_psol3,xm_psol,ym_psol);
br_splot(per2,xm_psol,ym_psol);
axis([8.2 9.2 30 43]); set(gca,'FontSize',20);


