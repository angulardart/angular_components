#!/bin/bash
# Created with package:mono_repo v2.0.0

if [[ -z ${PKGS} ]]; then
  echo -e '\033[31mPKGS environment variable must be set!\033[0m'
  exit 1
fi

if [[ "$#" == "0" ]]; then
  echo -e '\033[31mAt least one task argument must be provided!\033[0m'
  exit 1
fi

EXIT_CODE=0

for PKG in ${PKGS}; do
  echo -e "\033[1mPKG: ${PKG}\033[22m"
  pushd "${PKG}" || exit $?
  pub upgrade --no-precompile || exit $?

  for TASK in "$@"; do
    case ${TASK} in
    command_0) echo
      echo -e '\033[1mTASK: command_0\033[22m'
      echo -e './tool/travis/install_protoc.sh'
      ./tool/travis/install_protoc.sh || EXIT_CODE=$?
      ;;
    command_1) echo
      echo -e '\033[1mTASK: command_1\033[22m'
      echo -e 'pub run build_runner build web'
      pub run build_runner build web || EXIT_CODE=$?
      ;;
    command_2) echo
      echo -e '\033[1mTASK: command_2\033[22m'
      echo -e 'pub run build_runner build web --release'
      pub run build_runner build web --release || EXIT_CODE=$?
      ;;
    dartanalyzer) echo
      echo -e '\033[1mTASK: dartanalyzer\033[22m'
      echo -e 'dartanalyzer --fatal-warnings .'
      dartanalyzer --fatal-warnings . || EXIT_CODE=$?
      ;;
    dartfmt) echo
      echo -e '\033[1mTASK: dartfmt\033[22m'
      echo -e 'dartfmt -n --set-exit-if-changed .'
      dartfmt -n --set-exit-if-changed . || EXIT_CODE=$?
      ;;
    test) echo
      echo -e '\033[1mTASK: test\033[22m'
      echo -e 'pub run test --run-skipped'
      pub run test --run-skipped || EXIT_CODE=$?
      ;;
    *) echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
      EXIT_CODE=1
      ;;
    esac
  done

  popd
done

exit ${EXIT_CODE}
