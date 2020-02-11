document.addEventListener("DOMContentLoaded", function(){
    renderRepos();
})


function getRepos() {
    fetch('http://localhost:3000/repos/')
    .then(res => res.json())
    .then(repos => renderRepos(repos))
    .catch(err => console.log(err))
}

function renderRepos(repos) {
    repos.forEach(repo => {
        showRepo(repo)
    });
}


function showRepo(repo) {
    let analyzedRepositories = document.getElementById("analyzed-repositories")
    let unanalyzedRepositories = document.getElementById("unanalyzed-repositories")

    let div = document.createElement("div")

    let p = document.createElement("p")
    p.textContent = repo.nickname
    
    let u = document.createElement("p")
    u.textContent = repo.url

    let button = document.createElement("button")
    button.textContent = "See Analysis"

    div.appendChild(p)
    div.appendChild(u)
    div.appendChild(button)
    analyzedRepositories.appendChild(div)
}

function newRepoForm(){

    let main = document.getElementById("main")

    let div = document.createElement("div")
    div.className = "card"

    div.innerHTML = "";

    let nickname = document.createElement("p")
    nickname.textContent = "Enter the nickname of your repository"

    let nicknameInput = document.createElement("input")
    nicknameInput.type = "text";
    
    let p = document.createElement("p")
    p.textContent = "Enter the Url of your repository"

    let input = document.createElement("input")
    input.type = "text";

    let button = document.createElement("button")
    button.textContent = "Submit Repository"
    button.addEventListener("click", () => {
        addRepository()
    })
    

    div.appendChild(nickname)
    div.appendChild(nicknameInput)
    div.appendChild(p)
    div.appendChild(input)
    div.appendChild(button)
    main.appendChild(div)
}

let button = document.getElementById("new-repo-form-button")
button.textContent = "Add a Repository"
button.addEventListener("click", () => {
    newRepoForm()
})

