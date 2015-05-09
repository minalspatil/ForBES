function out = GetPrimalOutput(prob, dualout)
    out.name = dualout.name;
    out.message = dualout.message;
    out.flag = dualout.flag;
    out.gam = dualout.gam;
    Ax = 0;
    y = dualout.x;
    if isfield(prob, 'f1')
        if isa(prob.A1, 'function_handle')
            [~, out.x1] = prob.callf1conj(-prob.A1t(y));
            Ax = Ax+prob.A1(out.x1);
        else
            [~, out.x1] = prob.callf1conj(-prob.A1'*y);
            Ax = Ax+prob.A1*out.x1;
        end
    end
    if isfield(prob, 'f2')
        if isa(prob.A2, 'function_handle')
            [~, out.x2] = prob.callf2conj(-prob.A2t(y));
            Ax = Ax+prob.A2(out.x2);
        else
            [~, out.x2] = prob.callf2conj(-prob.A2'*y);
            Ax = Ax+prob.A2*out.x2;
        end
    end
    mugam = prob.muB*out.gam;
    if isfield(prob, 'b')
        [out.z, ~] = prob.callg(-prob.B'*(y+out.gam*(Ax-prob.b))/mugam, 1/mugam);
    else
        [out.z, ~] = prob.callg(-prob.B'*(y+out.gam*Ax)/mugam, 1/mugam);
    end
    out.y = y;
    out.iterations = dualout.iterations;
    if isfield(dualout, 'operations'), out.operations = dualout.operations; end
    out.residual = dualout.residual;
    out.ts = dualout.ts;
    out.prob = prob;
    out.preprocess = dualout.preprocess;
end