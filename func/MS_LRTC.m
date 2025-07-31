function res = MS_LRTC(ksp, ref, kSize, nIter, R, tol)
% to implement a joint multi-slice SAKE using low rank tenosr completion
%
% Input
%       - ksp   : undersampled kspace data with size of [nx, ny, nc, nsli]
%       - ref   : ground truth data for error calculation.
%       - kSize : sliding window size to create Hankel Matrix, like [3, 3]
%       - nIter : the number of max Iterations
%       - R     : given ranks for low rank tensor approx.
%       - tol   : tolerence
%
% About "hosvd" function
%       - [Download](www.tensortoolbox.org/index.html)
%       - [Usage](www.tensortoolbox.org/hosvd_doc.html)
%
% (c) University of Virginia, Kang Yan
%

    mask = abs(ksp) > 0;
    [sx, sy, nc, ns] = size(ksp);
    
    nblk = (sx - kSize(1) + 1) * (sy - kSize(2) + 1);
    nvec = kSize(1) * kSize(2) * nc;
    Hsize = [nblk, nvec, ns];
    Psize = [nblk, kSize(1) * kSize(2), nc];
    res = ksp;
    for n = 1:nIter
        A = zeros(Hsize);
        for sli = 1:ns
            % create Casorati matrix from k-space patches
            tmp = im2row(res(:,:,:,sli), kSize);
            A(:,:,sli) = reshape(tmp, [nblk, nvec]);
        end
        
        % enforce the low-rank constraint on the k-sapce tensor
        A_lr = hosvd(tensor(A), tol, 'ranks', R);
        A_lr = double(full(A_lr));
        
        ksp_lr = zeros(sx, sy, nc, ns);
        for sli = 1:ns
            tmp_lr = reshape(A_lr(:,:,sli), Psize);
            ksp_lr(:,:,:,sli) = row2im(tmp_lr, [sx, sy, nc], kSize);
        end
        clear A A_lr tmp tmp_lr;

        % Enforce data consistency
        res = ksp_lr .* (1-mask) + ksp; 

        % Monitoring
        img_updated = ifft2c(res);
        figure(111), imshow(sos(squeeze(img_updated(:,:,:,1))), []); drawnow;
        fprintf('Iter: %2d, norm: %2.4f\n', n, norm(ksp_lr(:) - ref(:)) ./ norm(ref(:)));
    end


end