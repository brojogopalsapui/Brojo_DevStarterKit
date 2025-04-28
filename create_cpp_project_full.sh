#!/bin/bash

# create_cpp_project_full.sh
# Brojo's Ultimate C++ Project Creator and Bootstrapper

echo "🚀 Starting Full C++ Project Bootstrapper..."

# Step 1: Project Name
read -p "Enter your project name: " project_name

# Create folder structure
mkdir -p $project_name/{src,test,include,build,.vscode,.github/workflows}

# Step 2: Create CMakeLists.txt
cat <<EOL > $project_name/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project($project_name)

set(CMAKE_CXX_STANDARD 14)

include_directories(src include)

add_executable($project_name
    src/main.cpp
)

enable_testing()
find_package(GTest REQUIRED)
include_directories(\${GTEST_INCLUDE_DIRS})

add_executable(runUnitTests
    test/test_${project_name}.cpp
    src/main.cpp
)

target_link_libraries(runUnitTests \${GTEST_LIBRARIES} pthread)

add_test(NAME ${project_name}Tests COMMAND runUnitTests)
EOL

# Step 3: Create src/main.cpp
cat <<EOL > $project_name/src/main.cpp
#include <iostream>

int main() {
    std::cout << "Hello from $project_name!" << std::endl;
    return 0;
}
EOL

# Step 4: Create test/test_project.cpp
cat <<EOL > $project_name/test/test_${project_name}.cpp
#include <gtest/gtest.h>

TEST(BasicTest, HelloWorld) {
    EXPECT_EQ(2 + 2, 4);
}

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
EOL

# Step 5: Create .vscode/settings.json
cat <<EOL > $project_name/.vscode/settings.json
{
    "cmake.generator": "MinGW Makefiles",
    "cmake.buildDirectory": "\${workspaceFolder}/build",
    "terminal.integrated.defaultProfile.windows": "Git Bash",
    "cmake.configureOnOpen": true
}
EOL

# Step 6: Create README.md
cat <<EOL > $project_name/README.md
# $project_name

🚀 Auto-created C++ project.

## Build

\`\`\`bash
mkdir build
cd build
cmake ..
make
./$project_name
\`\`\`

## Test

\`\`\`bash
cd build
ctest --verbose
\`\`\`
EOL

# Step 7: Create .gitignore
cat <<EOL > $project_name/.gitignore
build/
*.o
*.out
*.exe
docs/
CMakeFiles/
CMakeCache.txt
Makefile
cmake_install.cmake
.vscode/
EOL

# Step 8: Create Dockerfile
cat <<EOL > $project_name/Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

RUN apt-get update && apt-get install -y \\
    g++ \\
    cmake \\
    make \\
    libgtest-dev \\
    doxygen \\
    graphviz \\
    git \\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /$project_name

COPY . .

RUN cmake .
RUN make

CMD ["./$project_name"]
EOL

# Step 9: Create GitHub Actions build.yml
cat <<EOL > $project_name/.github/workflows/build.yml
name: C++ Build and Test

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y g++ cmake make libgtest-dev

    - name: Build project
      run: |
        mkdir build
        cd build
        cmake ..
        make

    - name: Run tests
      run: |
        cd build
        ctest --verbose
EOL

# Step 10: Git initialization
cd $project_name
git init
git add .
git commit -m "Initial commit: $project_name project created"
echo "✅ Git repository initialized!"

# Final message
echo ""
echo "🎯 Project $project_name created successfully!"
echo "📂 Navigate into project: cd $project_name"
echo "🚀 Ready to build and push to GitHub!"
