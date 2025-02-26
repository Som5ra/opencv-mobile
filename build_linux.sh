wget -q https://github.com/nihui/opencv-mobile/releases/latest/download/opencv-mobile-4.10.0.zip
unzip -q opencv-mobile-4.10.0.zip
cd opencv-mobile-4.10.0

rm modules/calib3d/src/chessboard.*
cp ../customized/matchers.cpp modules/features2d/src/matchers.cpp
cp ../customized/options.txt options.txt

mkdir -p build_linux
cd build_linux
cmake -DCMAKE_INSTALL_PREFIX=install \
  -DCMAKE_BUILD_TYPE=Release \
  `cat ../options.txt` \
  -DBUILD_opencv_world=OFF ..
make -j4
make install

cd ..