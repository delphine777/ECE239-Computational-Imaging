lamp_syc(:,:,1) = lamp1(:,:,1) + 0.1*lamp2(:,:,1);

lamp_syc(:,:,2) = 0.5*lamp1(:,:,2) + 0.5*lamp2(:,:,2);

lamp_syc(:,:,3) = 0.1*lamp1(:,:,3) + lamp2(:,:,3);

figure()
imshow(x2lamps)
figure()
imshow(lamp_syc,[])

sub = x2lamps-lamp_syc;

figure()
imshow(sub,[])