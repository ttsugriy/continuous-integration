#!/bin/bash
#
# Copyright 2016 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Install a bootstrap bazel; we use the latest released version
PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)
BAZEL_VERSION=$(curl -sSI https://github.com/bazelbuild/bazel/releases/latest | grep '^Location: ' | sed 's|.*/||' | sed $'s/\r//')

curl -sSLo install.sh "https://releases.bazel.build/${BAZEL_VERSION}/release/bazel-${BAZEL_VERSION}-without-jdk-installer-${PLATFORM}.sh"
bash install.sh > /dev/null
bazel version

# Setup a system-wide bazelrc file. This should be kept to the minimum required
# as it also influences Bazel running inside our integration tests.
cat > /etc/bazel.bazelrc <<EOF
# Necessary fix for JVM crashing with SIGBUS (#3236), also improves hermeticity.
build --sandbox_tmpfs_path=/tmp

# Increase performance on SSDs / tmpfs.
build --experimental_multi_threaded_digest
EOF
