import axios from 'axios';

const ROOT_URL = 'https://api.github.com/users';
const USER_NAME = 'ncoop57';

export const FETCH_PROJECTS = 'FETCH_PROJECTS';

export function fetchProjects() {
  const request = axios.get(`${ROOT_URL}/${USER_NAME}/repos?per_page=100`);

  return {
    type: FETCH_PROJECTS,
    payload: request
  };
}