:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe
set JPEG_LIB=%LIBRARY_LIB%\libjpeg.lib
set CMAKE_ARGS=%CMAKE_ARGS% %JPEG_LIB%

mkdir build_src
cd build_src
cmake ^
    -G "Ninja" ^
    %CMAKE_ARGS% ^
    -DALLOW_IN_SOURCE_BUILD=ON ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON ^
    -DJAS_ENABLE_LIBHEIF=OFF ^
    -DJAS_ENABLE_DOC=OFF ^
    -DJAS_ENABLE_LIBJPEG=OFF ^
    -DJAS_ENABLE_OPENGL=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
