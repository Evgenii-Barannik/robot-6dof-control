SCRIPT_DIR=$(dirname "$(realpath "$0")")
cd "$SCRIPT_DIR"

conan install . --output-folder=build --build=missing
cd build
meson setup --native-file conan_meson_native.ini .. meson-src

meson compile -C meson-src
if [ $? -ne 0 ]; then
    echo "Meson compilation failed."
    exit 1
fi
cd ..

gcc -fPIC -shared -o cpython.so main.c -lgsl -lgslcblas          
if [ $? -ne 0 ]; then
    echo "C-Python compilation failed."
    exit 1
fi

chmod +x "$SCRIPT_DIR/build/meson-src/6dof"
"$SCRIPT_DIR/build/meson-src/6dof" | tee output.txt
