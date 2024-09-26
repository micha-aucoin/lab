#! /bin/bash


#############################################################
_get_functions() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: list_bash_functions <script_file>"
    return 1
  fi
  if [[ ! -f $1 ]]; then
    echo "Error: File '$1' does not exist."
    return 1
  fi
  echo
  grep -E '^\s*\w+\s*\(\)' "$1" \
    | sed -E 's/\(\)//; s/\s+.*$//' \
    | grep -v '^_' \
    | sort -u
    # Find the first word of each line followed by parentheses
    # Remove parentheses
    # Exclude lines that begin with underscore
    # Unique sort
  echo
}
#############################################################
_is_file() {
  show_error="$1"
  shift # Remove the first argument and shift remaining arguments
  for file in "$@"; do
    if [ ! -f "$file" ]; then
      if [ "$show_error" -eq 1 ]; then
        echo
        echo "Error: The file '$file' does not exist or is not accessible."
        echo
      fi
      return 1
    fi
  done
}
#############################################################
_update_cluster_context() {
  # Prompt the user to select cluster context
  while true; do
    echo
    echo "Available cluster contexts:"
    echo "$(kubectl config get-contexts -o name)"
    echo
    echo -n "Select context: "
    read -r CLUSTER_CONTEXT
    if kubectl config get-contexts "$CLUSTER_CONTEXT" >/dev/null 2>&1; then
      echo "set variable CLUSTER_CONTEXT=$CLUSTER_CONTEXT"
      break
    else
      echo "Cluster context '$CLUSTER_CONTEXT' does not exist. Please try again."
    fi
  done
}
#############################################################


get_pub_key() {
  if [ "$#" != 1 ]; then
    echo
    echo "Example:"
    echo "get_pub_key \\"
    echo "  <~/where/do/you/want/pub/key?>"
    echo
    return 1
  fi

  _is_file 0 "$1" && {
    echo
    echo "public key $1 already exists."
    echo
    return 0
  }

  _update_cluster_context

  kubeseal --fetch-cert \
    --controller-name=sealed-secrets-controller \
    --controller-namespace=flux-system \
    --context="$CLUSTER_CONTEXT" \
    > "$1"

  echo
  echo "pub key saved to $1."
}


create_sealed_secret() {
  # Initialize variables
  local source=""
  local target=""
  local pub_key=""
  local name=""
  local namespace=""

  # Parse named arguments
  for arg in "$@"; do
    case $arg in
      source=*)
        source="${arg#*=}"
        ;;
      target=*)
        target="${arg#*=}"
        ;;
      pub-key=*)
        pub_key="${arg#*=}"
        ;;
      name=*)
        name="${arg#*=}"
        ;;
      namespace=*)
        namespace="${arg#*=}"
        ;;
      *)
        echo "Unknown argument: $arg"
        return 1
        ;;
    esac
  done

  # check variables exist
  if [ -z "$source" ] \
  || [ -z "$target" ] \
  || [ -z "$pub_key" ] \
  || [ -z "$name" ] \
  || [ -z "$namespace" ]; then
    echo "Error: Missing required arguments."
    echo "Example:"
    echo "create_sealed_secret \\"
    echo "  source=<(pass show source-file) \\"
    echo "  target=<path-to-output.yaml> \\"
    echo "  pub-key=<path-to-pub-key> \\"
    echo "  name=<name> \\"
    echo "  namespace=<namespace>"
    return 1
  fi

  # Check if the public key file exists
  _is_file 1 "$pub_key" || return 1

  # Read the source file content from stdin and create the sealed secret
  kubectl create secret generic "$name" \
    --from-env-file=/dev/stdin \
    --namespace="$namespace" \
    --dry-run=client -o yaml \
    < "$source" \
    | kubeseal \
    --format=yaml \
    --cert="$pub_key" \
    >> "$target" || {
    echo "Error: Failed to create the sealed secret."
    return 1
  }

  echo
  echo "Sealed secret created and saved to $target."
}
