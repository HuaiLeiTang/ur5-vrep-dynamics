mdl_ur5;
ur5.offset(2)=-1.57;
ur5.offset(6)=-1.57;
ur5.links(1,1).I=[0.010267495893 0 0;0 0.010267495893 0; 0 0 0.00666];
ur5.links(1,2).I=[0.22689067591 0 0; 0 0.22689067591 0; 0 0 0.0151074];
ur5.links(1,3).I=[0.049443313556 0 0; 0 0.049443313556 0; 0 0 0.004095];
ur5.links(1,4).I=[0.111172755531 0 0;0 0.111172755531 0; 0 0 0.21942];
ur5.links(1,5).I=[0.111172755531 0 0;0 0.111172755531 0; 0 0 0.21942];
ur5.links(1,6).I=[0.0171364731454 0 0; 0 0.0171364731454 0; 0 0 0.033822];
ur5.links(1,1).Jm = 0;
ur5.links(1,2).Jm = 0;
ur5.links(1,3).Jm = 0;
ur5.links(1,4).Jm = 0;
ur5.links(1,5).Jm = 0;
ur5.links(1,6).Jm = 0;

% q=[0 pi/2 0 pi/2 0 0];
% qd = [0 0 0 0 0 0];
% qdd = [0 0 0 0 0 0];
% G = [0 0 9.81];
% tau = ur5.rne(q,qd,qdd,'gravity',G)