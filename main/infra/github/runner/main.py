from os import environ
from time import sleep

from dotenv import load_dotenv
from github import Github
from github.GithubException import GithubException

from runner.db import student_dataframe

load_dotenv()

SEMESTER_REPO_PREFIX = "fall23"
ORGANIZATION = "UCB-W255"
STUDENT_TEAM_ID = 5538453


student_list = student_dataframe["github_username"].to_list()

print(student_list)


def runner():
    g = Github(environ["GITHUB_PAT"])

    org = g.get_organization(ORGANIZATION)
    student_team = org.get_team(STUDENT_TEAM_ID)

    # Add Everyone to Org
    for student in student_list:
        print(f"Processing {student}")
        user = g.get_user(student)
        repo = f"{SEMESTER_REPO_PREFIX}-{student}"

        # check for repo and if exist move on
        try:
            test = g.get_repo(f"{ORGANIZATION}/{repo}")
        except GithubException:
            test = None

        if test:
            continue

        try:
            org.invite_user(user)
            student_team.add_membership(user)
            repo = org.create_repo(repo, private=True)
            sleep(5)
            repo.add_to_collaborators(user, permission="admin")
        except GithubException as e:
            print(f"    {e}")
