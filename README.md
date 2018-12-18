# Triggered pipelines project

This project is used to trigger pipelines from webhook triggers.

## Mirror pipelines

Mirror pipelines allow to mirror an external repository (SRC) to a destination
repository (DEST).

To add a new repository mirroring, perform the following steps:

* choose a name for your project. Example: ``prefix``
* this name will be used to name your pipeline variables: ``PREFIX_...``
* generate a personal token for you source and target repository
* add the following variables here: https://gitlab.tools.kobalt.fr/kobalt/pipeline-triggers/settings/ci_cd
  * ``PREFIX_SRC_REPO``: ``https://_USER_:_TOKEN_@github.com/organization/repo.git``
  * ``PREFIX_SRC_USER``
  * ``PREFIX_SRC_TOKEN``
  * ``PREFIX_DEST_REPO``: ``https://_USER_:_TOKEN_@gitlab.tools.kobalt.fr/group/repo.git``
  * ``PREFIX_DEST_USER``
  * ``PREFIX_DEST_TOKEN``
* create a branch on pipeline-triggers: ``git checkout -b mirror-prefix master``
* configure your webhooks on github: https://github.com/organization/repo/settings/hooks
  * ``https://gitlab.tools.kobalt.fr/api/v4/projects/39/ref/mirror-<prefix>/trigger/pipeline?token=<TOKEN>``
  * replace \<prefix\> by your prefix
  * replace \<TOKEN\> with a token from https://gitlab.tools.kobalt.fr/kobalt/pipeline-triggers/settings/ci_cd

## References

* gitlab personal tokens management: https://gitlab.tools.kobalt.fr/profile/personal_access_tokens
* github personal tokens management: https://github.com/settings/tokens
