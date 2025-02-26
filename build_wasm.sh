wget -q https://github.com/nihui/opencv-mobile/releases/latest/download/opencv-mobile-4.10.0.zip
unzip -q opencv-mobile-4.10.0.zip
cd opencv-mobile-4.10.0

rm modules/calib3d/src/chessboard.*
cp ../customized/matchers.cpp modules/features2d/src/matchers.cpp
cp ../customized/options.txt options.txt


source $(echo $(which emcc) | sed 's|/emsdk/.*|/emsdk/emsdk_env.sh|')

mkdir -p build_wasm_simd
cd build_wasm_simd
cmake -DCMAKE_TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
    -DCPU_BASELINE="" -DCPU_DISPATCH="" -DWITH_PTHREADS_PF=OFF -DCV_ENABLE_INTRINSICS=OFF -DBUILD_WASM_INTRIN_TESTS=OFF \
    -DCMAKE_C_FLAGS="-frtti -fexceptions -s WASM=1 -s USE_PTHREADS=0" \
    -DCMAKE_CXX_FLAGS="-frtti -fexceptions -s WASM=1 -s USE_PTHREADS=0" \
    `cat ../options.txt` -DBUILD_opencv_world=OFF -DOPENCV_DISABLE_FILESYSTEM_SUPPORT=ON ..
make -j4
make install

cd ..