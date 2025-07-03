# Yapperbuilder

Yapperbuilder is a Ruby on Rails application designed to compare a creator's GitHub activity (commits) with their Telegram channel posts. It aims to provide insights into the balance between development work and community engagement.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

*   Ruby (version specified in `.ruby-version`)
*   PostgreSQL

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Asrat77/yapperbuilder.git
    cd yapperbuilder
    ```
2.  **Install dependencies:**
    ```bash
    bundle install
    ```
3.  **Set up the database:**
    ```bash
    rails db:create
    rails db:migrate
    ```
4.  **Run tests (optional but recommended):**
    ```bash
    bundle exec rspec
    ```
5.  **Start the development server:**
    ```bash
    rails s
    ```

The application should now be accessible at `http://localhost:3000`.

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Ensure tests pass (`bundle exec rspec`).
5.  Commit your changes (`git commit -m 'feat: Add new feature'`).
6.  Push to your branch (`git push origin feature/your-feature-name`).
7.  Open a Pull Request.