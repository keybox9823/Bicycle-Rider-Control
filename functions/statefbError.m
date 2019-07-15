function en = statefbError(X,np,bike_m, dat)


out = modelSimlinkPredict(X,bike_m,dat);
output=[out.roll_angle,out.steer_angle];

e = (output - np.y);
en = ((sum(e.^2)) * 1 / np.N);
en=en(1);
end