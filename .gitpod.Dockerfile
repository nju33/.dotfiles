FROM gitpod/workspace-full

RUN echo "$GPG_SECRET_KEY_NJU33" | base64 --decode > key \
  && gpg --batch --import --allow-secret-key-import key \
  && shred --remove key